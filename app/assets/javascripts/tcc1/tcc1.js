(function(){
    var app = angular.module('Application');

    app.controller('TimelineController', ['$http', 'messageCenterService', function($http, messageCenterService){
        var that = this;
        var cookies = document.cookie.split('=');
        that.teacher = JSON.parse(cookies[1]);

        that.years = [2010, 2011, 2012, 2013, 2014, 2015];
        that.halfs = [1, 2];
        that.year = new Date().getFullYear();
        that.half = 1;
        that.tcc = 1;
        that._ctrlForm = false;

        $http.get('/api/student/all').success(function(data){
            that.allStudents = data;
        });

        $http.get('/api/teacher/all').success(function(data){
            that.allTeachers = data;
        });

        that.updateStudents = function(){
            if(that.year && that.half && that.tcc){
                $http.get('/api/timeline/find/'+that.year+'/'+that.half+'/'+that.tcc).success(function(data){
                    if(data.timelines){
                        that.timelines = data.timelines;
                    }else if(data.errors){
                        messageCenterService.add('danger', 'Nenhum TCC encontrado.', {timeout: 3000});
                    }
                });
            }
        }
        that.updateStudents();

        that.updateTimeline = function(){
            $http.get('/api/timeline/base/search/'+ that.year+'/'+ that.half+'/'+ that.tcc).success(function(data){
                base_calendar = data.data;
                if(that.timeline){
                    header(base_calendar.json, that.timeline.items, that.half, function(){
                        body(that.timeline.items);
                        events(that.timeline.items);
                        that._ctrlTimeline = true;
                    });
                }
            });
        }
    }]);
})();