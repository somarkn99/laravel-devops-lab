<?php

use Illuminate\Support\Facades\Route;
use Laravel\Horizon\Horizon;

Route::get('/', function () {
    return view('welcome');
});

Horizon::auth(
    function ($request) {
        return true;
    }
);
