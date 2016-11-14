var app = angular.module('recognitionApp', []).controller('mainController', ['$http',
 function($http) {
    "use strict";
    
    var self = this;

    self.message = 'Results: Classifier';

    self.submit = function() {
        self.message = Date.now();
        console.log('button clicked!', self.message);
    };
}]);
