# SkillHub Training Portal – Implementation Specification (for the coding agent)

This file, together with `SkillHub_project_report_v2.md`, defines the project to build or update. **The report is the design. This file gives the exact details the report leaves out.** If the two ever disagree, follow the report and mention the disagreement in your reply. The existing project code may be partly built; update it to match, keep what already conforms, and do not rewrite working code needlessly.

## 0. Rules

1. Java 17, Maven, packaging `war`, **Jakarta EE 10** (`jakarta.*` imports only; never `javax.*`). Target: GlassFish 7. Context root `/SkillHub-1.0`.
2. Only dependency: `jakarta.platform:jakarta.jakartaee-web-api:10.0.0` with scope `provided`. **No other libraries.**
3. **No database. No JSTL. No Expression Language** (do not write `${...}` anywhere in JSP text). JSP pages use scriptlets (`<% %>`), expression tags (`<%= %>`), page directives and `<jsp:include>` only.
4. This is a simple assessment project for a beginner module (Web Component Development I). Keep code **simple and readable**, with short comments. Do not add frameworks, abstractions, interfaces, dependency injection, or features not listed here.
5. Do not add or rename servlets, URLs, packages or attribute names. Use exactly the names in this file.
6. Passwords are plain text by design. Do not add hashing.
7. Each servlet is declared in exactly one place: `@WebServlet` **or** `web.xml`. Only `LogoutServlet` and `ProfileServlet` are declared in `web.xml` (no `@WebServlet` on them). Filter and listeners are declared in `web.xml` only (no `@WebFilter`, no `@WebListener`).
8. Use the `web.xml` from report Section 5.3 **verbatim**.
9. Never use `request.getSession()` or `getSession(true)` except in `LoginServlet` after a successful login. Everywhere else use `getSession(false)` and handle `null`.
10. All forms that change data use POST and the servlet ends with `response.sendRedirect(request.getContextPath() + ...)`. All pages are displayed by `RequestDispatcher.forward()` to a JSP under `/WEB-INF/views/`.

## 1. `pom.xml`

- `groupId` `com.skillhub`, `artifactId` `SkillHub`, `version` `1.0`, `packaging` `war`.
- Properties: `maven.compiler.release` = 17, `project.build.sourceEncoding` = UTF-8.
- Dependency as in rule 2. `maven-war-plugin` 3.4.0.
- **Do not set `<finalName>`** (the WAR must be `SkillHub-1.0.war`).

## 2. File list (exact)

```
src/main/java/com/skillhub/model/{Role,AttendanceStatus,User,Course,Enrollment,AttendanceRecord}.java
src/main/java/com/skillhub/data/DataStore.java
src/main/java/com/skillhub/util/HtmlUtil.java
src/main/java/com/skillhub/filter/AuthFilter.java
src/main/java/com/skillhub/listener/{AppContextListener,SessionListener}.java
src/main/java/com/skillhub/controller/{LoginServlet,LogoutServlet,RegisterServlet,DashboardServlet,CourseServlet,EnrollmentServlet,AttendanceServlet,TrainerServlet,ProfileServlet}.java
src/main/webapp/index.jsp
src/main/webapp/css/style.css
src/main/webapp/WEB-INF/web.xml
src/main/webapp/WEB-INF/views/{login,register,dashboard,courses,add-course,add-trainer,enroll-student,attendance,profile,error,menu}.jsp
```

Delete any other leftover files (for example sample `HelloServlet`, unused JSPs, a `jsp/` folder in the web root).

## 3. Model (`com.skillhub.model`)

All classes are simple: private final fields, constructor, getters. No setters, no Lombok.

| Class | Members |
|---|---|
| `Role` (enum) | `ADMIN`, `TRAINER`, `STUDENT` |
| `AttendanceStatus` (enum) | `PRESENT`, `ABSENT` |
| `User` | `String username, password, fullName, email; Role role`. Constructor `(username, password, fullName, email, role)`. |
| `Course` | `int id; String title, category, description, trainerUsername`. Constructor `(id, title, category, description, trainerUsername)`. |
| `Enrollment` | `String studentUsername; int courseId; LocalDate enrolledOn`. Constructor `(studentUsername, courseId, enrolledOn)`. |
| `AttendanceRecord` | `int courseId; String studentUsername; LocalDate date; AttendanceStatus status`. Constructor `(courseId, studentUsername, date, status)`. |

## 4. `DataStore` (`com.skillhub.data`)

Fields: `ConcurrentHashMap<String,User> users`, `ConcurrentHashMap<Integer,Course> courses`, `CopyOnWriteArrayList<Enrollment> enrollments`, `CopyOnWriteArrayList<AttendanceRecord> attendance`, `AtomicInteger courseIdCounter = new AtomicInteger(0)`.

| Method | Behaviour |
|---|---|
| `boolean addUser(User u)` | `users.putIfAbsent(u.getUsername(), u) == null`. Usernames are case-sensitive. |
| `User authenticate(String username, String password)` | Returns the user if the username exists and the password equals (plain text); otherwise `null`. Null-safe. |
| `User getUser(String username)` | Returns user or `null`. Null-safe. |
| `List<User> getUsersByRole(Role r)` | Sorted by `fullName` (case-insensitive). |
| `Course addCourse(String title, String category, String description, String trainerUsername)` | Id = `courseIdCounter.incrementAndGet()`. Stores and returns the course. |
| `Course getCourse(int id)` | Course or `null`. |
| `List<Course> getAllCourses()` | Sorted by id. |
| `List<Course> getCoursesByTrainer(String username)` | Sorted by id. |
| `synchronized boolean enroll(String username, int courseId)` | `false` if already enrolled; otherwise adds `new Enrollment(username, courseId, LocalDate.now())` and returns `true`. (Callers validate that the user and course exist.) |
| `boolean isEnrolled(String username, int courseId)` | |
| `List<Course> getCoursesOfStudent(String username)` | Sorted by id. |
| `List<User> getStudentsInCourse(int courseId)` | Enrolled users, sorted by `fullName`. |
| `int countEnrollments()` | Total number of enrolments. |
| `synchronized void saveAttendance(int courseId, LocalDate date, Map<String,AttendanceStatus> statuses)` | Remove all existing records for that `courseId` and `date`, then add one record per map entry. |
| `Map<String,AttendanceStatus> getAttendance(int courseId, LocalDate date)` | Username → status for that course and date (empty map if none). |
| `List<LocalDate> getSessionDates(int courseId)` | Distinct dates that have records for the course, **newest first**. |
| `int[] getAttendanceSummary(String username, int courseId)` | `{presentCount, totalCount}` over all that student's records for that course. |

The diagram in the report shows the main methods; these small helpers (such as `countEnrollments`) are allowed.

## 5. `HtmlUtil` (`com.skillhub.util`)

`public static String escape(String s)`: returns `""` for `null`; otherwise replaces `&` → `&amp;`, `<` → `&lt;`, `>` → `&gt;`, `"` → `&quot;`, `'` → `&#39;` (replace `&` first).

## 6. Listeners

**`AppContextListener implements ServletContextListener`**
`contextInitialized`: create `DataStore`, seed it (Section 7), `ctx.setAttribute("dataStore", store)`, `ctx.setAttribute("activeSessions", new AtomicInteger(0))`, `ctx.log("SkillHub started: sample data loaded")`. `contextDestroyed`: `ctx.log("SkillHub stopped")`.

**`SessionListener implements HttpSessionListener`**
`sessionCreated`: get the `AtomicInteger` from the context attribute `activeSessions` and `incrementAndGet()`. `sessionDestroyed`: `decrementAndGet()` (never below 0). Use `se.getSession().getServletContext()`.

## 7. Seed data (exact)

Users (all passwords plain text):

| username | password | fullName | email | role |
|---|---|---|---|---|
| `admin` | `admin123` | System Administrator | admin@skillhub.example | ADMIN |
| `trainer1` | `trainer123` | Kamal Silva | kamal@skillhub.example | TRAINER |
| `trainer2` | `trainer123` | Nimali Fernando | nimali@skillhub.example | TRAINER |
| `student1` | `student123` | Saman Kumara | saman@skillhub.example | STUDENT |
| `student2` | `student123` | Dilani Jayawardena | dilani@skillhub.example | STUDENT |

Courses (add in this order so ids are 1–4):

| id | title | category | description | trainer |
|---|---|---|---|---|
| 1 | Java Web Development | Technology | Servlets, JSP and web containers using Jakarta EE. | trainer1 |
| 2 | Python Fundamentals | Technology | Programming basics using Python. | trainer2 |
| 3 | Business Communication | Professional Development | Professional writing and presentation skills. | trainer2 |
| 4 | Project Management Essentials | Business | Planning, scheduling and managing projects. | trainer1 |

Enrolments: `student1` → course 1, `student2` → course 1.

Attendance for course 1 (relative to `LocalDate.now()`):

| date | student1 | student2 |
|---|---|---|
| today − 2 days | PRESENT | PRESENT |
| today − 1 day | ABSENT | PRESENT |

## 8. `AuthFilter` (`com.skillhub.filter`, mapped to `/*` in `web.xml`)

Pseudo-code:

```
HttpServletRequest req; HttpServletResponse resp;
String path = req.getRequestURI().substring(req.getContextPath().length());   // e.g. "/login", "" or "/"
if (isPublic(path)) { chain.doFilter(req, resp); return; }

HttpSession session = req.getSession(false);
User user = (session == null) ? null : (User) session.getAttribute("loggedUser");
if (user == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

if (path.startsWith("/admin/") && user.getRole() != Role.ADMIN)            -> resp.sendError(403); return;
if (path.equals("/enroll") && user.getRole() != Role.STUDENT)              -> resp.sendError(403); return;
if (path.equals("/attendance") && user.getRole() == Role.STUDENT)         -> resp.sendError(403); return;
chain.doFilter(req, resp);
```

`isPublic(path)`: `path` is `""`, `"/"`, `"/index.jsp"`, `"/login"`, `"/register"`, `"/favicon.ico"`, or starts with `"/css/"`.

Do not add `dispatcherTypes`; the default (REQUEST) is intended, so forwards to `WEB-INF` JSPs are not filtered again.

## 9. Servlets (`com.skillhub.controller`)

General conventions used below:
- `store` = `(DataStore) getServletContext().getAttribute("dataStore")`.
- `user` = `(User) req.getSession(false).getAttribute("loggedUser")` (the filter guarantees it exists for protected URLs).
- `VIEW` = `/WEB-INF/views/`. Forward with `req.getRequestDispatcher(VIEW + "x.jsp").forward(req, resp)`.
- Trim all text parameters. Treat `null` as empty.
- "Error re-display" = set request attribute `error` (String) plus the `form*` attributes listed, then forward to the same form JSP (HTTP 200).
- Validation rules for new accounts (used by `RegisterServlet` and `TrainerServlet`): username matches `[A-Za-z0-9_]{3,20}`; password length ≥ 4; fullName non-blank and ≤ 60 characters; email contains `@`. Error messages: `"All fields are required."`, `"Username must be 3-20 letters, digits or underscores."`, `"Password must be at least 4 characters."`, `"Enter a valid email address."`, `"That username is already taken."`.

### 9.1 `LoginServlet` – `@WebServlet("/login")`

- **GET:** if a session already has `loggedUser`, redirect to `/dashboard`. Otherwise read cookie `rememberedUser` from `req.getCookies()` (handle `null`) and set request attribute `savedUsername` (String, `""` if absent). Forward `login.jsp`.
- **POST:** params `username`, `password`, `remember` (checkbox, present when ticked).
  - Blank username or password → error `"Username and password are required."`, `savedUsername` = typed username, forward `login.jsp`.
  - `store.authenticate(...)` is `null` → error `"Invalid username or password."`, `savedUsername` = typed username, forward `login.jsp`.
  - Success → `req.getSession(true)`, `setAttribute("loggedUser", user)`. Cookie `rememberedUser` = username; `setPath(req.getContextPath())`, `setHttpOnly(true)`, `setMaxAge(remember != null ? 7*24*60*60 : 0)`; `resp.addCookie`. Redirect to `/dashboard`.

### 9.2 `LogoutServlet` – declared in `web.xml` (`/logout`)

- **GET:** `HttpSession s = req.getSession(false); if (s != null) s.invalidate();` then redirect to `/login?loggedOut=true`.

### 9.3 `RegisterServlet` – `@WebServlet("/register")`

- **GET:** forward `register.jsp`.
- **POST:** params `username`, `password`, `confirmPassword`, `fullName`, `email`. Apply the validation rules above plus `"Passwords do not match."`. On any error: re-display with `form`-attributes `formUsername`, `formFullName`, `formEmail`. Success: `store.addUser(new User(..., Role.STUDENT))`; if it returns `false` show the duplicate error; otherwise redirect to `/login?registered=true`.

### 9.4 `DashboardServlet` – `@WebServlet("/dashboard")`

- **GET:** set request attributes by role, then forward `dashboard.jsp`.
  - STUDENT: `myCourses` (`List<Course>` from `getCoursesOfStudent`), `attendanceSummaries` (`Map<Integer,int[]>`: courseId → `getAttendanceSummary`).
  - TRAINER: `myCourses` (`getCoursesByTrainer`), `studentsByCourse` (`Map<Integer,List<User>>`: courseId → `getStudentsInCourse`).
  - ADMIN: `trainerCount`, `studentCount` (sizes of `getUsersByRole`), `userCount` (= admins + trainers + students), `courseCount`, `enrollmentCount` (`countEnrollments()`), `activeSessions` (int value of the context `AtomicInteger`). All `Integer`.

### 9.5 `CourseServlet` – `@WebServlet(urlPatterns = {"/courses", "/admin/add-course"})`

Use `req.getServletPath()` to tell the URLs apart.
- **GET `/courses`:** attributes `courses` (`getAllCourses`), `trainerNames` (`Map<String,String>` trainer username → full name for every course's trainer), `enrolledIds` (`Set<Integer>`; for STUDENT the ids from `getCoursesOfStudent`, otherwise an empty set). Forward `courses.jsp`.
- **GET `/admin/add-course`:** attribute `trainers` (`getUsersByRole(TRAINER)`). Forward `add-course.jsp`.
- **POST `/admin/add-course`:** params `title`, `category`, `description`, `trainerUsername`. Validation: title, category, description non-blank (`"All fields are required."`); trainer exists with role TRAINER (`"Please choose a valid trainer."`). On error: re-display with `trainers`, `formTitle`, `formCategory`, `formDescription`, `formTrainer`. Success: `store.addCourse(...)`, redirect `/courses?msg=courseAdded`.
- Because one servlet serves two URLs, `doPost` must call `resp.sendError(405)` when the servlet path is `/courses` (only `/admin/add-course` accepts POST).

### 9.6 `TrainerServlet` – `@WebServlet("/admin/add-trainer")`

- **GET:** forward `add-trainer.jsp`.
- **POST:** params `username`, `password`, `fullName`, `email`. Same validation as registration (no confirm password). Error re-display attributes `formUsername`, `formFullName`, `formEmail`. Success: `addUser(new User(..., Role.TRAINER))`; redirect `/dashboard?msg=trainerAdded`.

### 9.7 `EnrollmentServlet` – `@WebServlet(urlPatterns = {"/enroll", "/admin/enroll"})`

- **POST `/enroll`** (student; the filter guarantees STUDENT): param `courseId` (int; parse errors → invalid). Course must exist, else redirect `/courses?msg=invalidCourse`. `store.enroll(user.getUsername(), courseId)`: `true` → redirect `/dashboard?msg=enrolled`; `false` → redirect `/courses?msg=alreadyEnrolled`.
- **GET `/admin/enroll`:** attributes `students` (`getUsersByRole(STUDENT)`), `courses` (`getAllCourses`). Forward `enroll-student.jsp`.
- **POST `/admin/enroll`:** params `studentUsername`, `courseId`. The student must exist with role STUDENT and the course must exist, else redirect `/admin/enroll?msg=invalid`. `enroll(...)` `true` → redirect `/admin/enroll?msg=enrolledByAdmin`; `false` → redirect `/admin/enroll?msg=alreadyEnrolled`.
- Because one servlet serves two URLs, `doGet` must call `resp.sendError(405)` when the servlet path is `/enroll` (only `/admin/enroll` accepts GET).

### 9.8 `AttendanceServlet` – `@WebServlet("/attendance")`

Filter has already blocked students. `isAdmin` = `user.getRole() == Role.ADMIN`.

- **GET:** params `courseId` (optional), `date` (optional, `yyyy-MM-dd`).
  - Always set `courses` = `isAdmin ? getAllCourses() : getCoursesByTrainer(username)`.
  - No `courseId` → forward `attendance.jsp` (course picker only).
  - With `courseId`: parse (error → redirect `/attendance?msg=invalidCourse`); `course = store.getCourse(id)`; `null` → same redirect. If TRAINER and `!course.getTrainerUsername().equals(user.getUsername())` → `resp.sendError(403)` and return.
  - `date`: `LocalDate.parse` in a try/catch; missing or invalid → `LocalDate.now()`.
  - Set attributes: `course`, `date` (`LocalDate`), `today` (`LocalDate.now()`), `students` (`getStudentsInCourse`), `statuses` (`getAttendance(courseId, date)`), `sessionSummaries` (`LinkedHashMap<LocalDate,int[]>` iterating `getSessionDates` newest first; `int[]{presentCount, absentCount}` from `getAttendance` for that date), `readOnly` (`Boolean`, true for admin). Forward `attendance.jsp`.
- **POST:** params `courseId`, `date`, and one param `status_<username>` for each enrolled student (value `PRESENT` or `ABSENT`).
  - If the user is not a TRAINER → `sendError(403)`.
  - Course must exist (else redirect `/attendance?msg=invalidCourse`) and be taught by this trainer (else `sendError(403)`).
  - `date` must parse (else redirect `/attendance?courseId=ID&msg=invalidDate`) and not be after today (else redirect `/attendance?courseId=ID&msg=futureDate`).
  - Build `Map<String,AttendanceStatus>` for **every enrolled student**: `PRESENT` only if the param equals `PRESENT`, otherwise `ABSENT`. Call `store.saveAttendance(...)`. Log with `getServletContext().log(...)`.
  - Redirect `/attendance?courseId=ID&date=YYYY-MM-DD&msg=attendanceSaved`.

### 9.9 `ProfileServlet` – declared in `web.xml` (`/profile`)

- **GET:** request attribute `academyName` = `getServletContext().getInitParameter("academyName")`. Forward `profile.jsp`.

## 10. JSP pages (`/WEB-INF/views/`, plus `/index.jsp`)

Common rules:
- `<%@ page contentType="text/html;charset=UTF-8" language="java" %>` at the top; import what is needed (`com.skillhub.model.*`, `com.skillhub.util.HtmlUtil`, `java.util.*`, `java.time.LocalDate`).
- **Every piece of user-entered or stored text printed in HTML goes through `HtmlUtil.escape(...)`.**
- Links and form actions: `<%= request.getContextPath() %>/path`.
- Include the stylesheet `<%= request.getContextPath() %>/css/style.css` in `<head>`.
- Public pages (`login.jsp`, `register.jsp`, `error.jsp`, and `/index.jsp`) start with `<%@ page session="false" %>` and do **not** include the menu.
- Private pages get the user with `User loggedUser = (User) session.getAttribute("loggedUser");` and start the `<body>` with `<jsp:include page="menu.jsp" />`.
- Request attributes are read with casts, e.g. `List<Course> courses = (List<Course>) request.getAttribute("courses");` (use `@SuppressWarnings("unchecked")` in a declaration or ignore the warning).
- Messages from `?msg=` codes: map known codes to text in a scriptlet using `if/else` or `switch`; **never print the raw parameter**; ignore unknown codes.

| Code | Text | Shown on |
|---|---|---|
| `enrolled` | You have been enrolled in the course. | dashboard |
| `trainerAdded` | Trainer account created. | dashboard |
| `courseAdded` | Course added successfully. | courses |
| `alreadyEnrolled` | Already enrolled in that course. | courses, enroll-student |
| `invalidCourse` | Invalid course. | courses, attendance |
| `enrolledByAdmin` | Student enrolled successfully. | enroll-student |
| `invalid` | Invalid student or course. | enroll-student |
| `attendanceSaved` | Attendance saved. | attendance |
| `futureDate` | Attendance cannot be recorded for a future date. | attendance |
| `invalidDate` | Invalid date. | attendance |

Also: on `login.jsp`, show "Registration successful. Please log in." if `request.getParameter("registered")` equals `"true"` and "You have been logged out." if `loggedOut` equals `"true"`.

### Page contents

| File | Content |
|---|---|
| `index.jsp` | `session="false"`; `response.sendRedirect(request.getContextPath() + "/login");` and nothing else. |
| `login.jsp` | Heading with `application.getInitParameter("academyName")`. Form POST `/login`: `username` (value = `savedUsername`), `password`, checkbox `remember` labelled "Remember my username", submit. Error from attribute `error`. Link to `/register`. |
| `register.jsp` | Form POST `/register`: `username`, `password`, `confirmPassword`, `fullName`, `email`; re-fill with `formUsername`, `formFullName`, `formEmail`. Error from `error`. Link back to `/login`. |
| `menu.jsp` | Fragment (no `<html>`). Shows "Logged in as {fullName} ({role})". Links: Dashboard, Courses, Profile, Logout. ADMIN also: Add trainer (`/admin/add-trainer`), Add course (`/admin/add-course`), Enrol student (`/admin/enroll`), Attendance (`/attendance`). TRAINER also: Attendance (`/attendance`). |
| `dashboard.jsp` | Message from `msg`. **STUDENT:** table of `myCourses` with columns Course, Attendance (e.g. `1 of 2 sessions (50%)`, computed from `attendanceSummaries.get(course.getId())`; show "No sessions yet" when total is 0; percentage = `Math.round(100.0 * present / total)`); text "You are not enrolled in any course" if empty. **TRAINER:** for each course in `myCourses`: title and the list of enrolled students (full name and username), with a link "Mark attendance" to `/attendance?courseId=ID`; read-only otherwise. **ADMIN:** table of counts: users, trainers, students, courses, enrolments, active sessions; links to the admin pages. |
| `courses.jsp` | Message from `msg`. Table: ID, Title, Category, Description, Trainer (full name from `trainerNames`), and for STUDENT an Action column: "Enrolled" text if the id is in `enrolledIds`, otherwise a small POST form to `/enroll` with hidden `courseId` and an "Enrol" button. ADMIN sees a link "Add course" above the table. TRAINER sees no action column. |
| `add-course.jsp` | Form POST `/admin/add-course`: `title`, `category`, `description` (textarea), `trainerUsername` (`<select>` listing `trainers` as "Full Name (username)"). Re-fill from `form*`. Error from `error`. If `trainers` is empty, show "Add a trainer first". |
| `add-trainer.jsp` | Form POST `/admin/add-trainer`: `username`, `password`, `fullName`, `email`. Re-fill and error as above. |
| `enroll-student.jsp` | Message from `msg`. Form POST `/admin/enroll`: `studentUsername` (`<select>` of `students`), `courseId` (`<select>` of `courses`, shown as "ID – Title"), submit. |
| `attendance.jsp` | Message from `msg`. **Course picker:** list of `courses` as links to `/attendance?courseId=ID` (text "No courses" if empty). **If `course` attribute is set:** heading with course title; a **GET form** (hidden `courseId`, `<input type="date" name="date" max="today" value="date">`, button "Load") to change the date; then, if `students` is empty, "No students are enrolled in this course." Otherwise, if `readOnly` is false (trainer): a **POST form** to `/attendance` with hidden `courseId` and hidden `date`, and for each student a row with two radio buttons named `status_<username>` (`PRESENT`, `ABSENT`); the radio matching `statuses.get(username)` is checked, and **PRESENT is checked by default when there is no record**; button "Save attendance". If `readOnly` is true (admin): a table of student and status text ("Present", "Absent", or "Not recorded") with **no form, no inputs and no save button**. Finally a "Past sessions" table from `sessionSummaries`: Date (a link to `/attendance?courseId=ID&date=D`), Present count, Absent count. |
| `profile.jsp` | Table: Username, Full name, Email, Role, Academy (`academyName` attribute). |
| `error.jsp` | `session="false"`. Read `request.getAttribute("jakarta.servlet.error.status_code")` (an `Integer`, may be `null`). Show a friendly message: 403 "You do not have permission to open this page.", 404 "Page not found.", 500 "Something went wrong on the server.", otherwise "An error occurred." Include a link to `<%= request.getContextPath() %>/dashboard`. Never print exception details. |

### `style.css`

Simple, clean styling is enough: body font and background, a centred `.container` (max-width about 900px), a horizontal `.menu` bar, bordered tables with padding, form field spacing, `.error` (red text) and `.success` (green text) classes. No external fonts or libraries.

## 11. Cookies and sessions (summary)

- Session cookie `JSESSIONID`: created by the container on `getSession(true)` at login only; HttpOnly and cookie-only tracking are configured in `web.xml`.
- `rememberedUser` cookie: see `LoginServlet`. It stores the username only.
- Never put a password in a cookie. Never use `encodeURL`, `jsessionid` or URL rewriting.

## 12. Acceptance checklist

Build with `mvn clean package` (must succeed, producing `target/SkillHub-1.0.war`), deploy on GlassFish 7, and verify the scenarios T01–T24 in report Section 11.4 using the sample data in Section 7 above. In particular:

1. `student1` logs in, sees course 1 with `1 of 2 sessions (50%)`.
2. After `trainer1` marks today's attendance for course 1 (`student1` PRESENT), `student1` sees `2 of 3 sessions (67%)`.
3. `trainer1` opening `/SkillHub-1.0/attendance?courseId=2` gets the 403 error page.
4. `student1` opening `/SkillHub-1.0/attendance` or `/SkillHub-1.0/admin/add-course` gets the 403 error page.
5. `admin` can add a trainer, add a course for that trainer, and enrol a student; the admin attendance page has no save button.
6. A logged-out request to any protected URL redirects to `/login`; a logged-in request to an unknown URL shows the 404 error page.
7. Public pages create no session before login (check that `JSESSIONID` appears only after a successful login).
8. The code contains no `javax.`, `${`, `<c:`, `@WebFilter`, `@WebListener`, or `getSession(true)` outside `LoginServlet`.

When finished, reply with a short list of the files created or changed and anything you could not do exactly as specified.
