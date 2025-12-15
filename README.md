# Physical Checkup System (Laravel)

## 📌 نظرة عامة

هذا المشروع هو نظام **فحص صحي (Physical Checkup)** مبني باستخدام **Laravel**، يهدف إلى إدارة:

* المستخدمين
* الحالات المرضية (Sickest)
* الفحوصات البسيطة (Simples)
* عمليات الفحص (Checkup)

يعتمد النظام على بنية MVC القياسية في Laravel مع مصادقة مستخدمين (Login / Logout).

---

## 🗂️ هيكلية المشروع

```
app/
 ├─ Http/Controllers
 ├─ Models
routes/
 └─ web.php
resources/
 └─ views/
database/
 ├─ migrations
```

---

## 🛣️ Routes (routes/web.php)

### المصادقة

| Method | URL     | Controller      | Function | الوصف                     |
| ------ | ------- | --------------- | -------- | ------------------------- |
| GET    | /login  | LoginController | login    | عرض صفحة تسجيل الدخول     |
| POST   | /check  | LoginController | check    | التحقق من بيانات المستخدم |
| POST   | /logout | LoginController | logout   | تسجيل الخروج              |

### لوحة التحكم

| Method | URL        | Middleware | View      |
| ------ | ---------- | ---------- | --------- |
| GET    | /dashboard | auth       | dashboard |

### Resource Routes

تم استخدام `Route::resource` لإنشاء CRUD كامل:

| Resource | Controller        |
| -------- | ----------------- |
| /user    | UserController    |
| /simples | SimplesController |
| /sickest | SickestController |
| /checkup | CheckesController |

---

## 🎮 Controllers

### 1️⃣ LoginController

* `login()` : عرض صفحة تسجيل الدخول
* `check()` : التحقق من بيانات المستخدم
* `logout()` : إنهاء الجلسة

### 2️⃣ UserController

إدارة المستخدمين (CRUD):

* إنشاء مستخدم
* تعديل بياناته
* حذف المستخدم

### 3️⃣ SimplesController

إدارة الفحوصات البسيطة:

* إضافة فحص
* تعديل فحص
* حذف فحص

### 4️⃣ SickestController

إدارة الحالات المرضية:

* تسجيل الأمراض
* تعديل بيانات المرض

### 5️⃣ CheckesController

يمثل جوهر النظام:

* ربط الفحص بالمريض
* ربط الفحص بالحالة المرضية
* تخزين نتائج الفحص

---

## 👁️ Views (resources/views)

الواجهات مبنية باستخدام Blade وتشمل:

* صفحة تسجيل الدخول
* لوحة التحكم
* صفحات CRUD لكل من:

  * Users
  * Simples
  * Sickest
  * Checkup

---

## 🧠 Models

### User

يمثل المستخدمين (أطباء / موظفين)

### Catagory

يمثل تصنيفات المنتجات أو الفحوصات

### Product

يمثل المنتجات المرتبطة بالفحص

### Simples

يمثل الفحوصات البسيطة

### Sickest

يمثل الحالات المرضية

### Checkes

يمثل عملية الفحص ويرتبط بـ:

* Sickest
* Simples
* User

---

## 🗄️ قاعدة البيانات (Database Schema)

### users

| الحقل    | النوع  |
| -------- | ------ |
| id       | bigint |
| name     | string |
| email    | string |
| password | string |

### sickests

| الحقل       | النوع  |
| ----------- | ------ |
| id          | bigint |
| name        | string |
| description | text   |

### simples

| الحقل        | النوع  |
| ------------ | ------ |
| id           | bigint |
| name         | string |
| normal_value | string |

### checkes

| الحقل      | النوع     |
| ---------- | --------- |
| id         | bigint    |
| user_id    | FK        |
| sickest_id | FK        |
| simple_id  | FK        |
| result     | string    |
| created_at | timestamp |

---

## 🔗 العلاقات بين الجداول

* User **hasMany** Checkes
* Sickest **hasMany** Checkes
* Simples **hasMany** Checkes
* Checkes **belongsTo** User / Sickest / Simples

---

## ⚙️ متطلبات التشغيل

* PHP >= 8
* Laravel
* MySQL

## 🚀 خطوات التشغيل

```bash
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate
php artisan serve
```

---

## 📄 ملاحظات

* المشروع يعتمد على Laravel Resource Controllers
* قابل للتوسعة بإضافة تقارير طبية أو رسوم بيانية

---

## ✍️ Author

Physical Checkup System – Laravel MVC Project
