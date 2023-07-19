#!/bin/bash
php artisan queue:work &
php artisan migrate
npm run build
php artisan optimize:clear
php artisan serve --host 0.0.0.0
