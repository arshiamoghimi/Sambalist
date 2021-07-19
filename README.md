
# Sambalist
<div dir="rtl">

# شرح کلی پروژه
در این پروژه، یک برنامه‌ی Todo List ساده با کمک swift پیاده‌سازی کرده‌ایم. همه‌ی کد‌ها در فایل `main.swift` پیاده‌سازی شده. اما بخش‌های مختلف آن با کمک کامنت 

</div>

```
// ================================= PART NAME =====================================

```

<div dir="rtl">

از هم جدا شده‌اند. دلیل این کار این بود که هیچ کدام از اعضای ما mac os نداشتند و پیاده‌سازی به صورت چند فایله در playground و نسخه‌ی ابونتو راحت نبود.

## روش اجرای پروژه
برای اجرای پروژه، کافی است کد زیر را در کامندلاین اجرا کنید:
  
</div>

```
swift main.swift
```

<div dir="rtl">

نسخه‌ی سوییفتی که با آن تست شده، `Swift version 5.4.1 (swift-5.4.1-RELEASE)` است.

# ساختار کد پروژه

## Third Patries

در این بخش، کد‌هایی که به عنوان utility از آن استفاده کردیم و پیاده‌سازی آن توسط خودمان انجام نشده، مثلا از stackoverflow برداشتیم وجود دارد. تنها پیدا کردن زمان کنونی به میلی ثانیه تابعی بود که در این بخش قرار می‌گیرد.

## Models
این بخش، شامل مدل‌های ماست. داده‌هایی که state اصلی برنامه را دارند و اگر می‌خواستیم ذخیره کنیم، باید آن‌ها ذخیره می‌شدند.

دیتابیس اصلی ما کلاس TaskBoard است که مشابه یک آبجکت singleton از آن استفاده می‌کنیم. این کلاس یک لیست از تسک‌ها و یک لیست از دسته‌بندی‌ها را دارد. و همچنین تغییرات روی داده مثل اضافه کردن، حذف و یا پیدا کردن یک عنصر در متد‌هایش پیاده‌سازی شده اند.

در کل از class استفاده کردیم چون دوست داشتیم آبجکت‌ها pass by reference باشند.

## Errors
در این قسمت اکسپشن‌ها یا خطاهایی که ممکن است بخوریم وجود دارد. تنها خطایی که در نظر گرفتیم، خطا در بررسی معتبر بودن دسته‌بندی و یکتا بودن نام است.

## CLI Helper
این قسمت، توابعی که برای نمایش و اطلاعات دادن به کاربر از آن‌ها استفاده می‌کنیم پیاده‌سازی شده اند. در این قسمت، استفاده از کلاس‌ها برای جدا کردن بخش‌های مختلف است و بیشتر شبیه namespaceهای مختلف از آن‌ها بهره برده ایم.

کلاس اول Color است که کمک می‌کند بتوانیم رنگ نوشته‌ی ترمینال را تغییر دهیم.

کلاس GUIHelper، توابعی مربوط به رسم محیط کاربری را دارد. تابع اول `drawMenu` است که یک نام و یک لیست از گزینه‌ها می‌گیرد، سپس منوها را به کاربر نشان می‌دهد. در صورتی که کاربر یک منو را انتخاب کند، اکشن run مربوط به آن منو صدا زده می‌شود.

تابع `drawSelectBox` مشابه منو است با این تفاوت که یک مقدار از پیش مشخص دارد و کاربر  انگار از بین چند گزینه که به صورت radio button دارد باید یکی را انتخاب کند.

تابع `drawPrioritySelectBox` مشابه تابع قبل و برای حالت خاص Priorityهاست.

تابع `printDivider` برای رسم یک خط جداکننده در صفحه است.

کلاس سوم `TasksGUI` است. این کلاس وظیفه نمایش تسک‌ها موجود را روی صفحه دارد.

کلاس `CategoriesManagementGUI`، رابط کاربری مربوط به بخش دسته‌بندی‌ها را هندل می‌کند و کلاس `TaskManagementGUI` رابط کاربری بخش تسک‌ها

## Logic
بخش قواعد و اینکه مثلا یک آپشن چه کاری انجام دهد اینجا پیاده شده.
ابتدا یک پروتوکل CommandLineOption را ساخته ایم. هرجا چند گزینه به کاربر نمایش می‌دهیم، کاربر باید یکی را انتخاب کند و بعد از انتخاب باید یک رویداد رخ دهد. از CommandLineOption برای ایجاد گزینه و دستورالعمل آن رویداد استفاده کرده ایم.
کلاس AnonymousOption، برای ساختن یک آبجکت از پروتوکل بالاست، بدون اینکه کلاس را مشخصا با اسم تعریف کنیم و با closureها این کار را انجام دهیم. این کلاس به ما کمک می‌کند در جاهایی که نیاز به استفاده‌ی مجدد از کامند نیست و کار کامند ساده و inline است، از زیاد و پیچیده کردن کد جلوگیری کنیم.

### منوی اصلی
اول لاجیک مربوط به منوی اصلی است.
این منو ۳ گزینه دارد.
1. گزینه‌ی اول اضافه کردن یک تسک جدید است که پیاده‌سازی آن در کلاس `CreateTaskOption` انجام شده.
2. گزینه‌ی دوم، رفتن به صفحه‌ی مدیریت دسته‌بندی‌هاست که CategoriesManagementGUI را باز میکند.
3. گزینه‌ی سوم، هم بستن برنامه‌ست :)


### بورد تسک‌ها
این کلاس به این صورت است که یک ترتیب روی تسک‌ها دارد، سپس قابلیت تغییر این ترتیب و انجام اکشن‌هایی روی یک تسک را به کاربر می‌دهد. همچنین در هر مرحله لیست تسک‌ها را با آن ترتیب نشان می‌دهد.
و کلاس بک هیچ کاری نمی‌کند و  باعث برگشتن به عقب می‌شود :) 

### دسته بندی‌ها
دسته‌ بندی‌ها چند کلاس دارند که به ترتیب برای کارهای زیر است:
1. لیست دسته‌بندی‌ها را ببینیم
2. یک دسته‌بندی موجود را پاک کنیم. این کلاس به تسک بورد می‌گوید دسته بندی را پاک کن. اگر توانست پیام موفقیت آمیز و اگر نتوانست در کنسول پیام اینکه کتگوری پیدا نشد چاپ می‌کنیم.
3. ایجاد دسته بندی جدید

### اکشن‌های یک تسک
بخش بعدی انجام اکشن‌ها روی یک تسک است.

1. اضافه/حذف کردن یک دسته بندی به یک تسک. به این صورت که اگر دسته بندی وجود داشت روی تسک حذف می‌شود و اگر نبود اضافه می‌شود، به اصطلاح toggle می‌کنیم.
2. حذف یک تسک
3. بروزرسانی اطلاعات یک تسک، به این صورت که فیلدی که باید بروز شود را می‌گیرد سپس مقدارش را با کمک ورودی کاربر به روز رسانی می‌کند.

## Main
کد از این بخش آغاز می‌شود. ابتدا یک سری اطلاعات از پیش مشخص در دیتابیس می‌ریزیم که کار کند. سپس منوی اصلی را نشان می‌دهیم.

# ویژگی‌ها
## امکان ایجاد یک آیتم todo با یک title، content و یک عدد به عنوان priority
در ابتدا + بزنید، سپس اطلاعات خواسته شده را وارد کنید: (خط‌هایی که با $ شروع شده ورودی کاربر هستند)

</div>
  
```
$ swift main.swift
=== Main Menu ===
+ => Create new task
l => Show tasks
c => Add / Show Categories
q => Quit
$ +
--------------------
Enter Title, Content and Priority of your task in 3 consecutive lines:
Title?
$ sample task
Content?
$ my sample content for task, this is a homework in swift :)
--------------------
Priority?
0 => high
1 => medium
2 => low
$ 1
✅Task created Successfully
--------------------
```

<div dir="rtl">

## امکان دیدن تمامی todoها در یک لیست
در منوی اصلی l بزنید :)
  
</div>
  
```
=== Main Menu ===
+ => Create new task
l => Show tasks
c => Add / Show Categories
q => Quit
$ l
--------------------
 === Tasks List ===
0. d: my task d
1. c: my task c
2. b: my task b
3. a: my task a
4. sample task: my sample content for task, this is a homework in swift :)
--------------------
=== Actions ===
b => Back to main menu
s => Sort
f => Filter by category
m => Manage a task
$ 
```

<div dir="rtl">

## امکان ویرایش title و content و priority یک آیتم لیست
در لیستی که بالا می‌بینید، می‌توانید هر یک از تسک‌ها را انتخاب کنید، برای این کار، ابتدا m بزنید. بعد آی‌دی تسک را باید وارد کنیم، مثلا برای a، عدد سه را وارد کنیم.
حال امکانات روی تسک دیده می‌شود، مثلا u برای آپدیت است. حال مثلا میخواهیم عنوانش را MY TASK A کنیم. صفر می‌نویسیم تا تایتل انتخاب شود و سپس MY TASK A را تایپ می‌کنیم.

</div>
  
```
--------------------
 === Tasks List ===
0. d: my task d
1. c: my task c
2. b: my task b
3. a: my task a
4. sample task: my sample content for task, this is a homework in swift :)
--------------------
=== Actions ===
b => Back to main menu
s => Sort
f => Filter by category
m => Manage a task
$ m
Please enter task ID
$ 3


--------------------
Task ID: 3
Task Title: a
Task Priority: high
Task Content: my task a
--------------------

=== Please select one of this actions ===
- => Remove task
u => Update task
c => Add/Remove Category
b => Back
$ u
--------------------
Please enter what value to edit
0 => title
1 => content
2 => priority
$ 0
$ MY TASK A
✅Task '3. MY TASK A' updated Successfully
--------------------
--------------------
 === Tasks List ===
0. d: my task d
1. c: my task c
2. b: my task b
3. MY TASK A: my task a
4. sample task: my sample content for task, this is a homework in swift :)
--------------------
=== Actions ===
b => Back to main menu
s => Sort
f => Filter by category
m => Manage a task
$ 
```

<div dir="rtl">

## امکان حذف یک آیتم
در همان مدیریت یک تسک‌. می‌توانیم حذف هم کنیم:

</div>
  
```
--------------------
 === Tasks List ===
0. d: my task d
1. c: my task c
2. b: my task b
3. MY TASK A: my task a
4. sample task: my sample content for task, this is a homework in swift :)
--------------------
=== Actions ===
b => Back to main menu
s => Sort
f => Filter by category
m => Manage a task
$ m
Please enter task ID
$ 3


--------------------
Task ID: 3
Task Title: MY TASK A
Task Priority: high
Task Content: my task a
--------------------

=== Please select one of this actions ===
- => Remove task
u => Update task
c => Add/Remove Category
b => Back
$ -
✅Task '3. MY TASK A' deleted Successfully
--------------------
--------------------
 === Tasks List ===
0. d: my task d
1. c: my task c
2. b: my task b
4. sample task: my sample content for task, this is a homework in swift :)
--------------------
=== Actions ===
b => Back to main menu
s => Sort
f => Filter by category
m => Manage a task
$ 
```

<div dir="rtl">

## امکان sort کردن
در همان لیست تسک‌ها، گزینه‌ی سورت که با s است دارد. بعد از کلیک روی آن، زمان ساخته شدن، عنوان و پریوریتی را دارد. همچنین می‌توانیم اگر یک چیز که انتخاب است را دوباره انتخاب کنیم، بین ASC و DESC جابه جا کنیم.
مثلا:
  
</div>

```
--------------------
 === Tasks List ===
0. d: my task d
1. c: my task c
2. b: my task b
4. sample task: my sample content for task, this is a homework in swift :)
--------------------
=== Actions ===
b => Back to main menu
s => Sort
f => Filter by category
m => Manage a task
$ s
--------------------
Enter sort key
 Current order: ASC
If you select currenly selected key, the order will be reversed
0 => creation date  <=
1 => name
2 => priority
$ 1
--------------------
 === Tasks List ===
2. b: my task b
1. c: my task c
0. d: my task d
4. sample task: my sample content for task, this is a homework in swift :)
--------------------
=== Actions ===
b => Back to main menu
s => Sort
f => Filter by category
m => Manage a task
$ s
--------------------
Enter sort key
 Current order: ASC
If you select currenly selected key, the order will be reversed
0 => creation date
1 => name  <=
2 => priority
$ 1
--------------------
 === Tasks List ===
4. sample task: my sample content for task, this is a homework in swift :)
0. d: my task d
1. c: my task c
2. b: my task b
--------------------
=== Actions ===
b => Back to main menu
s => Sort
f => Filter by category
m => Manage a task

```

<div dir="rtl">

همان طور که واضح است، بعد از انتخاب تسک‌ها به ترتیب الفبا مرتب شدند و دوباره که انتخاب کردم ترتیب تسک‌ها برعکس شد.

## امکان اضافه کردن دسته 
در main menu، دکمه‌ی مدیریت دسته‌هاست که می‌توان یک دسته جدید اضافه کرد و چک می‌کنیم روی name یکتا باشد.
  
</div>
  
```
--------------------
 === Tasks List ===
4. sample task: my sample content for task, this is a homework in swift :)
0. d: my task d
1. c: my task c
2. b: my task b
--------------------
=== Actions ===
b => Back to main menu
s => Sort
f => Filter by category
m => Manage a task
$ b
=== Main Menu ===
+ => Create new task
l => Show tasks
c => Add / Show Categories
q => Quit
$ c
--------------------
=== Category Management ===
+ => Create new category
l => Show list of categories
- => Delete category
b => Back
$ l
--------------------
== Categories:
0: cat 1
1: cat 2
2: cat 3


=== Main Menu ===
+ => Create new task
l => Show tasks
c => Add / Show Categories
q => Quit
$ c
--------------------
=== Category Management ===
+ => Create new category
l => Show list of categories
- => Delete category
b => Back
$ +
--------------------
Enter Title of your category in next line:
$ cat 4
✅Category created Successfully
--------------------
=== Main Menu ===
+ => Create new task
l => Show tasks
c => Add / Show Categories
q => Quit
$ c
--------------------
=== Category Management ===
+ => Create new category
l => Show list of categories
- => Delete category
b => Back
$ +
--------------------
Enter Title of your category in next line:
$ cat 4
❌ Category not created: Category name must be unique
--------------------
=== Main Menu ===
+ => Create new task
l => Show tasks
c => Add / Show Categories
q => Quit
$ 
```

<div dir="rtl">

## امکان اضافه کردن یک یا چند آیتم به یک دسته
این امکان به این صورت است که در مدیریت تسک، می‌توانیم به یک تسک دسته اضافه یا کم کنیم.
مثلا برای تسک sample task و d می‌خواهیم به دسته‌ی cat 3 اضافه‌شان کنیم.
  
</div>

```
--------------------
=== Main Menu ===
+ => Create new task
l => Show tasks
c => Add / Show Categories
q => Quit
$ l
--------------------
 === Tasks List ===
4. sample task: my sample content for task, this is a homework in swift :)
0. d: my task d
1. c: my task c
2. b: my task b
--------------------
=== Actions ===
b => Back to main menu
s => Sort
f => Filter by category
m => Manage a task
$ m
Please enter task ID
$ 4


--------------------
Task ID: 4
Task Title: sample task
Task Priority: medium
Task Content: my sample content for task, this is a homework in swift :)
--------------------

=== Please select one of this actions ===
- => Remove task
u => Update task
c => Add/Remove Category
b => Back
$ c
--------------------
Please select one of the categories or enter something else to cancel this action
 If the task is in the category it will be removed from the category, if not, it will be added.
0 => cat 1
1 => cat 2
2 => cat 3
3 => cat 4
$ 3
Category successfully added to task
--------------------
 === Tasks List ===
4. sample task: my sample content for task, this is a homework in swift :)
0. d: my task d
1. c: my task c
2. b: my task b
--------------------
=== Actions ===
b => Back to main menu
s => Sort
f => Filter by category
m => Manage a task
$ m
Please enter task ID
$ 0


--------------------
Task ID: 0
Task Title: d
Task Priority: high
Task Content: my task d
--------------------

=== Please select one of this actions ===
- => Remove task
u => Update task
c => Add/Remove Category
b => Back
$ c
--------------------
Please select one of the categories or enter something else to cancel this action
 If the task is in the category it will be removed from the category, if not, it will be added.
0 => cat 1
1 => cat 2
2 => cat 3
3 => cat 4
$ 3
Category successfully added to task
--------------------
 === Tasks List ===
4. sample task: my sample content for task, this is a homework in swift :)
0. d: my task d
1. c: my task c
2. b: my task b
--------------------
=== Actions ===
b => Back to main menu
s => Sort
f => Filter by category
m => Manage a task
$ f
--------------------
Please select one of categories or enter something else for no filtering
0 => cat 1
1 => cat 2
2 => cat 3
3 => cat 4
3
--------------------
 === Tasks List ===
4. sample task: my sample content for task, this is a homework in swift :)
0. d: my task d
--------------------
=== Actions ===
b => Back to main menu
s => Sort
f => Filter by category
m => Manage a task


```

<div dir="rtl">
  
## امکان مشاهده‌ی تسک‌های متعقل به یک دسته‌ی خاص
که در لیست تسک‌ها، گزینه‌ی فیلتر داریم. مثلا در همان اجرای نمونه‌ی بالا، تسک‌های متعلق به دسته‌ی cat 3 را فیلتر کرده ایم.

# اعضای تیم
 - ارشیا مقیمی - شماره دانشجویی: ۹۶۱۰۶۱۱۷
 - حامد علی‌محمدزاده - شماره دانشجویی:۹۶۱۰۲۰۲۹
 - علیرضا توفیقی محمدی - شماره دانشجویی: ۹۶۱۰۰۳۶۳

</div>
