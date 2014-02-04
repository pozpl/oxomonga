'use strict';

angular.module('GeoHashingApp')
    .controller('RegisterUserCtrl', ['$scope', '$rootScope', '$stateParams', '$http', '$upload',
        function ($scope, $http, $state, AuthenticationService) {

            $scope.submit = function () {
                if ($scope.password == $scope.reenter_password) {
                    var userRegistrationData = {
                        'login': $scope.login,
                        'email': $scope.email,
                        'password': $scope.password
                    };
                    $http({method: 'POST', url: '/user/register', data: userRegistrationData }).
                        success(function (data, status, headers, config) {
                            if (data && data.id) {
                                AuthenticationService.setLoggedIn(true);
                                $state.go('edit_user', {
                                    'id' : data.id
                                });
                            }
                        }).
                        error(function (data, status, headers, config) {
                            // called asynchronously if an error occurs
                            // or server returns response with an error status.
                        });
                }
            };

        }
    ]);


