'use strict';

angular.module('GeoHashingApp')
    .controller('EditUserCtrl', ['$scope', '$rootScope', '$stateParams', '$http', '$upload',
        function ($scope, $rootScope, $stateParams, $http, $upload) {

            $rootScope.textAngularOpts = {
                toolbar: [
                    ['h1', 'h2', 'h3', 'p', 'pre', 'bold', 'italics', 'ul', 'ol', 'redo', 'undo', 'clear'],
                    ['html', 'insertImage', 'insertLink']
                ],
                classes: {
                    toolbar: "btn-toolbar",
                    toolbarGroup: "btn-group",
                    toolbarButton: "btn btn-default",
                    toolbarButtonActive: "active",
                    textEditor: 'form-control',
                    htmlEditor: 'form-control'
                }
            };

            $scope.id = $stateParams.id;
            $scope.user = '';
            $scope.latitude = '';
            $scope.longitude = '';
            $scope.description = '';

            var getUser = function (userId) {
                $http({method: 'GET', url: '/users/get/user/json/' + userId}).
                    success(function (data, status, headers, config) {
                        if (data && data.id) {
                            showUser(data);
                        }
                    }).
                    error(function (data, status, headers, config) {
                        // called asynchronously if an error occurs
                        // or server returns response with an error status.
                    });
            };

            if ($scope.id) {
                getUser($scope.id);
            }

            $scope.submit = function () {
                var userJson = {
                    'id': $scope.id,
                    'user': $scope.user,
                    'latitude': $scope.latitude,
                    'longitude': $scope.longitude,
                    'description': $scope.description
                };

                $http({method: 'POST', url: '/users/edit/json', data: userJson }).
                    success(function (data, status, headers, config) {
                        if (data && data.id) {
                            showUser(data);
                        }
                    }).
                    error(function (data, status, headers, config) {
                        // called asynchronously if an error occurs
                        // or server returns response with an error status.
                    });
            };


            var showUser = function (userJson) {
                $scope.id = userJson.id;
                $scope.user = userJson.user;
                $scope.latitude = userJson.latitude;
                $scope.longitude = userJson.longitude;
                $scope.description = userJson.description;
                $scope.images = userJson.images;
            };


            $scope.onFileSelect = function ($files) {
                //$files: an array of files selected, each file has name, size, and type.
                for (var i = 0; i < $files.length; i++) {
                    var file = $files[i];
                    $scope.upload = $upload.upload({
                        url: '/user/upload/images',
                        // method: POST or PUT,
                        // headers: {'headerKey': 'headerValue'}, withCredential: true,
                        data: {'user_id': $scope.id},
                        file: file
                        // file: $files, //upload multiple files, this feature only works in HTML5 FromData browsers
                        /* set file formData name for 'Content-Desposition' header. Default: 'file' */
                        //fileFormDataName: myFile,
                        /* customize how data is added to formData. See #40#issuecomment-28612000 for example */
                        //formDataAppender: function(formData, key, val){}
                    }).progress(function (evt) {
                            console.log('percent: ' + parseInt(100.0 * evt.loaded / evt.total));
                        }).success(function (data, status, headers, config) {
                            // file is uploaded successfully
                            angular.forEach(data, function(image, key){
                                if($scope.images){
                                    $scope.images.push(image);
                                }else{
                                    $scope.images = [image];
                                }
                            });

                        });
                    //.error(...)
                    //.then(success, error, progress);
                }
            };

            $scope.deleteImage = function (imageId) {
                if ($scope.id) {
                    $http({method: 'POST', url: '/delete/user/image',
                            data: {
                                'user_id': $scope.id,
                                'image_id': imageId
                            }
                        }
                    ).
                        success(function (data, status, headers, config) {
                            if (data.status) {
                                var filteredImages = [];
                                angular.forEach($scope.images, function (image, key) {
                                    if (image.id != imageId) {
                                        this.push(image);
                                    }
                                }, filteredImages);

                                $scope.images = filteredImages;
                            }
                        }).
                        error(function (data, status, headers, config) {
                            // called asynchronously if an error occurs
                            // or server returns response with an error status.
                        });
                }
            }

        }]);


