angular.module('GeoHashingApp')
    .controller('MainMenuController',['$scope', '$location', 'AuthenticationService', function($scope, $location, AuthenticationService) {
        $scope.user = {
            isLoggedIn: AuthenticationService.isLoggedIn(),
            userId: AuthenticationService.getUserId()
        };

        $scope.isActive = function (viewLocation) {
            return viewLocation === $location.path();
        };
    }])
    .directive('mainMenu', function() {
        return {
            templateUrl: 'views/main_menu.html'
        };
    });
