'use strict';

angular.module('GeoHashingApp')
    .controller('LoginCtrl', ['$scope', '$rootScope', '$http', '$state' , 'AuthenticationService'
        , function ($scope, $rootScope, $http, $state, AuthenticationService) {

            var showLoginPage = function () {
                $scope.login = '';
                $scope.password = '';
            };

            showLoginPage();

            $scope.submit = function () {
                var authData = {
                    'login': $scope.login,
                    'password': $scope.password
                };
                $http({method: 'POST', url: '/login', data: authData}).
                    success(function (data, status, headers, config) {
                        if (data && data.status == 'ok') {
                            AuthenticationService.setLoggedIn(true);
                            if (AuthenticationService.getLastUnauthenticatedState()) {
                                $state.go(AuthenticationService.getLastUnauthenticatedState(), AuthenticationService.getLastUnauthenticatedStateParams());
                            } else {
                                $state.go('main_state');
                            }
                        }
                    }).
                    error(function (data, status, headers, config) {
                        // called asynchronously if an error occurs
                        // or server returns response with an error status.
                    });


            };

        }
    ]);


