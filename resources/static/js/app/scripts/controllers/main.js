'use strict';

angular.module('GeoHashingApp')
    .controller('MainCtrl', function ($scope) {
        $scope.awesomeThings = [
            'HTML5 Boilerplate',
            'AngularJS',
            'Karma'
        ];

        $scope.markers = [
            {coordinates:[56.56, 38.63], properties: {balloonContent: 'Здесь рыбы нет!'}},
            {coordinates:[55.16, 39.89], properties: {balloonContent: 'Здесь рыбы тоже нет'}},
            {coordinates:[55.08, 38.96], properties: {balloonContent: 'А здесь есть!'}}
        ];

        $scope.map = {
            center: [55.55, 39.84], zoom: 12
        };

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
