<?php
return array(
    'extends' => 'bootstrap3',
    'css' => array(
        //'vendor/bootstrap.min.css',
        //'vendor/bootstrap-accessibility.css',
        //'vendor/font-awesome.min.css',
        //'bootstrap-custom.css',
        'compiled.css',
        'print.css:print',
        'custom.css',
        'font/flaticon.css'
    ),
    'js' => array(
        'vendor/base64.js:lt IE 10', // btoa polyfill
        'vendor/jquery.min.js',
        'vendor/bootstrap.min.js',
        'vendor/bootstrap-accessibility.min.js',
        'vendor/validator.min.js',
        'lib/form-attr-polyfill.js', // input[form] polyfill, cannot load conditionally, since we need all versions of IE
        'lib/autocomplete.js',
        'common.js',
        'lightbox.js',
        'custom.js'
    ),
    'less' => array(
        'active' => false,
        'compiled.less'
    ),
    //Descomentar esta línea si se quiere usar un favicon.ico
    'favicon' => 'favicon.ico',
    'helpers' => array(
        'factories' => array(
            'flashmessages' => 'VuFind\View\Helper\Bootstrap3\Factory::getFlashmessages',
            'layoutclass' => 'VuFind\View\Helper\Bootstrap3\Factory::getLayoutClass',
            'recaptcha' => 'VuFind\View\Helper\Bootstrap3\Factory::getRecaptcha',
            'recorddataformatter' => 'LaReferencia\View\Helper\Root\RecordDataFormatterFactory',
        ),
        'invokables' => array(
            'highlight' => 'VuFind\View\Helper\Bootstrap3\Highlight',
            'search' => 'VuFind\View\Helper\Bootstrap3\Search'
        )
    )
);
