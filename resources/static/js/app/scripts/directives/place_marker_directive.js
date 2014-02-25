angular.module('GeoHashingApp')
    .controller('PlaceMarkerController',['$scope' , function($scope) {

    }])
    .directive('placeMarker', function() {
        return {
            templateUrl: 'views/place_marker_directive.html'
        };
    });
