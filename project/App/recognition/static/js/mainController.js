var app = angular.module('recognitionApp', ['ngResource']);

// app.config(function($interpolateProvider){
//     $interpolateProvider.startSymbol('{[{').endSymbol('}]}');
// });

app.controller('mainController', ['$http',
 function($http) {
    "use strict";
    
    var self = this;

    self.message = 'Classifier: Airplane';
    self.images = ['bed.jpg', 'industrial.jpg', 'street.jpg',
                   'forrest.jpg', 'kitchen.jpg', 'suburb.jpg',
                   'highway.jpg', 'mountain.jpg', 'tallbuilding.jpg'];

    self.selected_image = 'bed.jpg';
    self.resImg = '';
    self.response = false;

    self.upload = function(file) {
        console.log(file);
    }

    self.submit = function(data) {
        var url = '';
        if (typeof data !== 'undefined') {
            url = data.url;
        }
        var choice = data.choice;
        data = {'url': url, 'img': self.selected_image, 'choice': choice};
        console.log('button clicked!', self.message, data);
        $http.post("classify", data).then(function(response) {
            console.log("Response from classiier: ",response);
            self.message = response.data.classifier;
            self.resImg = self.selected_image;
            self.response = true;
            console.log(self.selected_image);
        })
    };

    self.selectImage = function (image) {
        if(self.selected_image === image) {
            self.selected_image = '';
        }
        else {
            self.selected_image = image;
        }
    };
}]);
