# شراكة (Sharaka)

منصة استثمار بالأسهم للمشاريع الخليجية — Flutter + Supabase.

---

## 1) قبل الرفع على GitHub

المشروع جاهز بالكامل: كل الشاشات (13 شاشة)، الموديلات، خدمة Supabase، وهيكل Android
كامل (`android/` بكل ملفاته بما فيها `gradlew` و`gradle-wrapper.jar`) — ما بيحتاج تشغّل
`flutter create` من جديد.

### الخطوات محلياً (على جهازك)

```bash
cd sharaka_app
flutter pub get
cp .env.example .env
# افتح .env وحط بيانات مشروع Supabase الحقيقية (SUPABASE_URL و SUPABASE_ANON_KEY)
flutter run   # للتجربة محلياً
```

> ملف `.env` موجود بـ `.gitignore` عمداً — ما لازم يترفع على GitHub لأنه فيه مفاتيح حساسة.
> بيانات الاتصال بـ Supabase بتنضاف بشكل منفصل وآمن جوا Codemagic (خطوة 3).

### رفع المشروع على GitHub

```bash
cd sharaka_app
git init
git add .
git commit -m "Initial commit - Sharaka investment platform"
git branch -M main
git remote add origin https://github.com/USERNAME/sharaka-app.git
git push -u origin main
```

---

## 2) إعداد قاعدة بيانات Supabase

1. أنشئ مشروع جديد على [supabase.com](https://supabase.com)
2. من **SQL Editor** نفّذ ملف `supabase_schema.sql` الموجود بجذر المشروع — بينشئ:
   - جدول `profiles` (المستخدمين بأدوارهم: مستثمر / صاحب مشروع / إدارة)
   - جدول `projects` (المشاريع)
   - جدول `investments` (الاستثمارات)
   - جدول `notifications` (الإشعارات)
   - سياسات RLS (Row Level Security) لكل جدول
   - Storage buckets: `kyc-documents` (خاص) و`project-files` (عام)
3. من **Settings > API** انسخ:
   - `Project URL` → `SUPABASE_URL`
   - `anon public key` → `SUPABASE_ANON_KEY`

---

## 3) ربط GitHub بـ Codemagic والبناء

1. سجّل دخول [codemagic.io](https://codemagic.io) واربط حساب GitHub
2. اختر مستودع `sharaka-app` → Codemagic بيكتشف `codemagic.yaml` تلقائياً
3. **قبل أول Build**، روح لـ:
   `App settings > Environment variables`
   - أنشئ مجموعة (Group) باسم **sharaka_secrets** بالضبط (نفس الاسم الموجود بـ codemagic.yaml)
   - أضف بداخلها متغيرين:
     - `SUPABASE_URL` = رابط مشروعك
     - `SUPABASE_ANON_KEY` = المفتاح العام
   - فعّل "Secure" لكل واحد فيهم
4. من تبويب **Start new build** اختر workflow: **android-release**
5. بعد اكتمال البناء (~8-15 دقيقة أول مرة)، حمّل:
   - `app-release.apk` → للتجربة المباشرة على أي جوال أندرويد
   - `app-release.aab` → للنشر على Google Play

> ملاحظة: التوقيع حالياً مؤقت بمفتاح debug عشان تقدر تبني وتجرب فوراً.
> قبل النشر الفعلي على Google Play لازم توقيع Release حقيقي (راجع القسم التالي).

---

## 4) توقيع Release حقيقي (قبل النشر على المتجر)

1. أنشئ keystore:
   ```bash
   keytool -genkey -v -keystore sharaka-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias sharaka
   ```
2. ارفع الـ keystore على Codemagic: `App settings > Code signing identities > Android`
3. عدّل `android/app/build.gradle` بقسم `signingConfigs.release` ليستخدم التوقيع الحقيقي
   بدل `signingConfigs.debug` المؤقت الموجود حالياً.

---

## 5) الحالة القانونية (تذكير)

منصات التمويل الجماعي بالأسهم بسلطنة عُمان تخضع لترخيص هيئة سوق المال العُمانية (FSA).
هذا المشروع جاهز تقنياً بالكامل، لكن قبل استقبال أي استثمار حقيقي بفلوس فعلية، تأكد من
استكمال الترخيص التنظيمي مع محامٍ مختص بأسواق المال العُماني/الخليجي.

---

## البنية التقنية

```
lib/
  core/
    constants/      → ثوابت التطبيق (أدوار، حالات، قوائم)
    services/        → SupabaseService (Auth + DB + Storage)
    theme/           → الهوية البصرية (أخضر داكن + ذهبي)
  models/            → UserModel, ProjectModel, InvestmentModel
  widgets/           → ProjectCard, CustomButton, StatusBadge, CustomTextField
  screens/
    splash/          → شاشة البدء + توجيه حسب الدور
    auth/            → تسجيل دخول / حساب جديد / KYC
    owner/           → لوحة المشاريع / إضافة مشروع / متابعة المستثمرين
    investor/        → استعراض / تفاصيل / استثمار / محفظة
    common/          → إشعارات / ملف شخصي
    admin/           → لوحة اعتماد المشاريع ومراجعة KYC
  routes/            → GoRouter (كل المسارات)
  main.dart

android/             → هيكل أندرويد كامل وجاهز (gradlew مضمّن)
codemagic.yaml       → إعدادات بناء APK/AAB و IPA
supabase_schema.sql  → سكيما قاعدة البيانات كاملة مع RLS
```

## الخطوة القادمة المقترحة

- ربط بوابة دفع خليجية فعلية (Thawani لعُمان أو Tap/PayTabs) بشاشة `invest_screen.dart`
  (حالياً فيها TODO محدد بمكان الربط بالضبط)
- إضافة رفع صور/مستندات المشروع الفعلية بشاشة `add_project_screen.dart`
- اختبار التطبيق الكامل بعد إدخال بيانات Supabase الحقيقية
