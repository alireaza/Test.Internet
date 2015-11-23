#!/bin/bash

###################################################
# این برنامه در زمان اجرا بررسی می کند که آیا شما به Internet وصل هستید یا خیر؟ ( با بررسی دسترسی به https://www.google.com )
# اگر ارتباط برقرار شود، پیغام موفقیت نمایش داده میشود. در صورتی که قابلیت پخش صدا فعال باشد، صدایی که برای ارتباط موفق تنظیم شده است پخش میشود.
# اگر ارتباط برقرار نشود، پیغام عدم ارتباط نمایش داده میشود. در صورتی که قابلیت پخش صدا فعال باشد، صدایی که برای ارتباط ناموفق تنظیم شده است پخش میشود.
# این کار هر چند ثانیه تکرار میشود و پایانی ندارد، مگر برنامه را متوقف کنید.
###################################################
# در صورت فعال بودن صدا، پس از هر بار بررسی ارتباط:
# در صورت وصل بودن یا وصل شدن ارتباط فقط یک بار صدا پخش میشود.
# در صورت قطع بودن یا قطع شدن ارتباط پس از پخش صدا به تعداد دفعات تنظیم شده در nosound صدا پخش نمیشود.
###################################################

delayforConnect="60" # هر چند ثانیه بررسی کردن ارتباط در صورت موفق بودن
delayforDisConncet="5" # هر چند ثانیه بررسی کردن ارتباط در صورت قطع بودن
sound="yes" # صدا پخش شود؟
volume="100" # میزان بلندی صدا به درصد
soundforConnect="./ok.ogg" # صدا پخش شود؟
soundforDisConncet="./connection.ogg" # صدا پخش شود؟
nosound="12" # هر چندبار صدا پخش نشود؟

################################################## از اینجا به بعد را دست نزنید. ##################################################

isconnect="no" # متغیر موقت برای بررسی اینکه ارتباط برقرار است یا نه؟
dontpalysound="0" # متغیر موقت برای پخش  نشدن صدا. در صورت 0 بودن صدا پخش می شود
if [ "100" < "$volume" ]; then volume="100"; fi

while [ true = true ] # حلقه نامحدود
do
	clear # پاک سازی خط فرمان

	wget -q --spider https://www.google.com # بررسی ارتباط

	if [ $? -eq 0 ] # اگر مقدار 0 بازگرداند
	then
		echo "Internet is connected!" # نمایش پیغام برقرار بودن ارتباط

		if [ "$sound" = "yes" ] && [ "$isconnect" = "no" ] # اگر پخش صدا فعال بود و ارتباط قطع شده بود
		then
			dontpalysound="0"
			isconnect="yes"
			paplay --volume=$(($volume*655)) $soundforConnect # پخش صدا برای ارتباط موفق
		fi

		delay_counter=$delayforConnect # متغیر موقت برای شمارش معکوس
		while [ "$delay_counter" != "0" ] # تا زمان 0 شدن متغیر حلقه ادامه دارد
		do
			tput cup 1 0 # تغییر مکان خروجی متن به خط اول خط فرمان
			sleep 1 # ایجاد تاخیر به ثانیه
			((delay_counter --)) # کم کردن مقدار از متغیر شمارش معکوس
			echo "# I will retry internet connection after $delay_counter seconds." # نمایش پیغام شمارش معکوش
		done
	else
		echo "Internet connection droped! Check your internet connection!" # نمایش پیغام برقرار نبودن ارتباط

		if [ "$sound" = "yes" ] && [ "$dontpalysound" = "0" ] # اگر پخش صدا فعال بود و متغیر پخش نشدن صدا 0 بود
		then
			dontpalysound=$nosound
			isconnect="no"
			paplay --volume=$(($volume*655)) $soundforDisConncet # پخش صدا برای ارتباط قطع
		fi

		delay_counter=$delayforDisConncet # متغیر موقت برای شمارش معکوس
		while [ "$delay_counter" != "0" ]
		do
			tput cup 1 0 # تغییر مکان خروجی متن به خط اول خط فرمان
			sleep 1 # ایجاد تاخیر به ثانیه
			((delay_counter --)) # کم کردن مقدار از متغیر شمارش معکوس
			echo "# Check your internet connection!! I will retry after $delay_counter seconds." # نمایش پیغام شمارش معکوش
		done

		((dontpalysound --))  # کم کردن مقدار از متغیر پخش نکردن صدا
	fi
done
