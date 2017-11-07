// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require bootstrap-datepicker
//= require rails-ujs
//= require turbolinks
//= require_tree .

function checkPage(className) {
    $('li.'+className).addClass('Active');
}

function PrintDiv() {
    var divToPrint = document.getElementsByClassName('print-details')[0];
    var popupWin = window.open('', '_blank', 'width=300,height=300');
    popupWin.document.open();
    popupWin.document.write('<html><body onload="window.print()">' + divToPrint.innerHTML + '</html>');
    popupWin.document.close();
    popupWin.close();
}

function setVisibleSearchButton(e) {
    if ((e.value.length > 3) && (e.value.length < 8)) {
        $('.search-form-button')[0].classList.remove("hidden");
    } else {
        $('.search-form-button')[0].classList.add("hidden");
    }
}

function setSpinner() {
    $('#page-preloader').show();
}