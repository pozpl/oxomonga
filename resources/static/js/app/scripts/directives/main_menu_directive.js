angular.module('GeoHashingApp')
    .controller('MainMenuController',['$scope' , 'AuthenticationService', function($scope, AuthenticationService) {
        $scope.user = {
            isLoggedIn: AuthenticationService.isLoggedIn(),
            userId: AuthenticationService.getUserId()
        };
    }])
    .directive('mainMenu', function() {
        return {
            templateUrl: 'views/main_menu.html'
        };
    });
