'use strict';

angular.module('testAngularApp')
    .controller('MainCtrl', function ($scope) {
        $scope.awesomeThings = [
            'HTML5 Boilerplate',
            'AngularJS',
            'Karma'
        ];

        $scope.geoObjects =
        {
            geometry: {
                type: 'Circle',
                coordinates: [37.60, 55.76],
                radius: 10000
            },
            properties: {
                balloonContent: "Радиус круга - 10 км",
                hintContent: "Подвинь меня"
            }
        };
    });
