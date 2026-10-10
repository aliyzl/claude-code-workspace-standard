# Needs a person

Things no agent can decide or verify. Each item says **why**, so it is clear who can unblock it.

| reason | why it blocks an agent |
| --- | --- |
| **business decision** | the answer is the owner's choice about money, law, product or direction |
| **owner's account** | it needs a registration, a payment or a login that only the owner holds |
| **owner's call by rule** | spending, publishing, deploying, merging, pushing and deleting are the owner's |
| **needs a network or device** | this laptop's VPN exits abroad, so it cannot see what a customer on a local mobile network sees |

## سؤال‌های باز شما (خلاصه، فارسی)

- **#1 — مقصد بکاپ بیرون از سرور:** پیشنهاد: یک باکت ذخیره‌سازی خارج از کشور، به‌اضافه‌ی یک کپی هفتگی پیش خودتان. گزارش کامل در `reports/2026-10-02-backup-destination/`.
- **#2 — شناسه‌ی پذیرنده‌ی درگاه پرداخت:** باید خودتان در تنظیمات پنل فروشگاه وارد کنید؛ در چت نفرستید.
- **#3 — تست پرداخت با گوشی واقعی روی اینترنت موبایل:** از روی این لپ‌تاپ ممکن نیست.

## Open

| # | item | reason | since |
| --- | --- | --- | --- |
| 1 | **An off-site backup destination.** Until one exists, a disk failure on `prod` loses the database and its backups together. Options and costs: [`reports/2026-10-02-backup-destination/`](reports/2026-10-02-backup-destination/README.md) | business decision; owner's account | 2026-10-02 |
| 2 | **The payment gateway's merchant id**, entered by the owner in the panel's settings. It is never sent through chat | owner's account | 2026-10-01 |
| 3 | **A real checkout on a phone over mobile data.** The laptop's VPN exits abroad, so a successful test here proves nothing about customers | needs a network or device | 2026-10-03 |

## Closed

| item | outcome | date |
| --- | --- | --- |
| Should this workspace get a private GitHub remote? | **Yes, private** («آره، خصوصی بساز»). Created as `<owner>/workspace-acme-shop` | 2026-10-01 |
