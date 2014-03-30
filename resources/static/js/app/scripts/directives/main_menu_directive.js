angular.module('GeoHashingApp')
    .controller('MainMenuController', ['$scope', '$location', 'AuthenticationService', function ($scope, $location, AuthenticationService) {

        $scope.$on('$stateChangeStart', function () {
            $scope.user = {
                isLoggedIn: AuthenticationService.isLoggedIn(),
                userId: AuthenticationService.getUserId()
            };
        });
    }])
    .directive('mainMenu', [function () {
        return {
            templateUrl: 'js/app/views/main_menu.html'
        };
    }])
    .directive('navMenu', function ($location) {
        return function (scope, element, attrs) {
            var links = element.find('a'),
                onClass = attrs.navMenu || 'on',
                routePattern,
                link,
                url,
                currentItem,
                urlMap = {},
                i;

            if (!$location.$$html5) {
                routePattern = /^#[^/]*/;
            }


            scope.$on('$stateChangeStart', function () {
                for (i = 0; i < links.length; i++) {
                    link = angular.element(links[i]);
                    url = link.attr('href');

                    if ($location.$$html5) {
                        urlMap[url] = link;
                    } else {
                        urlMap[url.replace(routePattern, '')] = link;
                    }
                }

                var pathLink = urlMap[$location.path()];
                if (pathLink) {
                    var pathItem = pathLink.parent();
                    if (currentItem) {
                        currentItem.removeClass(onClass);
                    }
                    currentItem = pathItem;
                    currentItem.addClass(onClass);
                }
            });
        };

//        return {
////            templateUrl: 'views/main_menu.html',
//            link: link
//        };
    });
