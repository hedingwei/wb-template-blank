<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script>

    $['router'] = new Router().init();

    (function($){
        let CHARS = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split('');
        function ApplicationInit(el,...mixin){
            if(el==undefined){
                throw "未指定dom元素，无法挂载";
                return;
            }
            if(mixin==undefined){
                mixin={}
            }
            let simpleApplicationMixin = {
                data(){
                    return {
                        base:'${pageContext.request.contextPath}'=='/'?'':'${pageContext.request.contextPath}',
                        apiConfig: {
                            ajax:{
                                urlBase: '${pageContext.request.contextPath}'=='/'?'':'${pageContext.request.contextPath}',
                                timeout: 60000
                            },
                            eventBus:{
                                listeners:{},
                                event:{}
                            }
                        },
                        urlManagement:{
                            parameterCache: {}
                        },
                        route: {
                            router:{}
                        },

                        models: {},
                        context: {}
                    }
                },
                mounted: function(){
                    console.log('simple application mounted..');
                },
                created: function(){
                    console.log('simple application created.')
                    this.route.router = $['router'];

                },
                methods: {
                    route_on: function(path, ...methods){
                        this.route.router.on(path,methods);
                    }
                },
            };
            let all = [simpleApplicationMixin];
            for(let i=0;i<mixin.length;i++){
                all.push(mixin[i]);
            }

            return new Promise(((resolve, reject) => {
                let vueGlobal = new Vue({
                    mixins:all,
                    created(){
                        console.log("Application Framework created")
                        try{
                            window['Application'] = this;
                        }catch (e){
                            console.log(e)
                        }
                        try{
                            resolve(this);
                        }catch (e){
                            console.log(e);
                            reject(this,e);
                        }
                    },
                    mounted: function(){
                        console.log("Application Framework mounted")
                        try{
                            u = $.url();
                            let path = u.attr()['fragment'];
                            if(path!=""){
                                this.routeTo(path);
                            }

                        }catch (e){

                        }
                    },
                    methods:{
                        ajax_post: function(url,param){
                            let that = this;
                            if(param==undefined){
                                param = {}
                            }
                            return new Promise(((resolve, reject) => {
                                $.ajax({
                                    type: "POST",
                                    url: that.apiConfig.ajax.urlBase+url,
                                    data: param,
                                    timeout: that.timeout,
                                    success: function(msg){
                                        console.log(msg)

                                        if(msg['code']==20000){
                                            resolve(msg);
                                        }else{
                                            reject(msg);
                                            that.$message(msg['msg']);
                                        }

                                    },
                                    error: function(msg){
                                        reject(msg);
                                        that.$message(msg);
                                    }
                                });
                            }))
                        },

                        ajax_post_json: function(url,param){
                            let that = this;
                            if(param==undefined){
                                param = {}
                            }
                            return new Promise(((resolve, reject) => {
                                $.ajax({
                                    type: "POST",
                                    url: that.apiConfig.ajax.urlBase+url,
                                    dataType: 'text',
                                    contentType: "application/json;charset=UTF-8",
                                    data: JSON.stringify(param),
                                    timeout: that.timeout,
                                    success: function(msg){
                                        msg = JSON.parse(msg);
                                        if(msg['code']==20000){
                                            resolve(msg);
                                        }else{
                                            reject(msg);
                                            that.$message(msg['msg']);
                                        }

                                    },
                                    error: function(msg){
                                        reject(msg);
                                        that.$message(msg);
                                    }
                                });
                            }))
                        },

                        ajax_get: function(url,param){
                            let that = this;
                            if(param==undefined){
                                param = {};
                            }
                            return new Promise(function (resolve,reject){
                                $.ajax({
                                    type: "GET",
                                    url: that.apiConfig.ajax.urlBase+url,
                                    contentType: "application/json; charset=utf-8",
                                    data: param,
                                    dataType: "json",
                                    async: true,
                                    timeout: that.timeout,
                                    success: function(msg){
                                        msg = JSON.parse(msg)
                                        if(msg['code']==20000){
                                            resolve(msg);
                                        }else{
                                            reject(msg);
                                        }
                                    },
                                    error: function(msg){
                                        reject(msg);
                                    }
                                });
                            });
                        },

                        watchEvent: function(event,obj){
                            try{
                                if(!this.apiConfig.eventBus.listeners[event]){
                                    this.apiConfig.eventBus.listeners[event]=[];
                                }
                                this.apiConfig.eventBus.listeners[event].push(obj);
                            }catch (e){
                                console.log(e);
                            }
                        },
                        fireEvent: function (event,parameter){
                            try{
                                let listeners = this.apiConfig.eventBus.listeners;
                                if(!listeners[event]){
                                    listeners[event]=[];
                                }
                                for(let i=0;i<listeners[event].length;i++){
                                    try{
                                        listeners[event][i][event](parameter);
                                    }catch (e1){
                                        console.log(e1);
                                    }
                                }
                            }catch (e){
                                console.log(e);
                            }
                        },

                        local_get: function (key){
                            try{
                                let value = localStorage.getItem(key);
                                if((value=='true')||(value=='false')){
                                    value = value=='true'?true:false
                                }
                                return value;
                            }catch (e){
                                console.log(e);
                            }
                            return undefined;
                        },
                        local_put: function(key, value){
                            try{
                                if((value==true)||(value==false)){
                                    value = value?"true":"false"
                                }
                                localStorage.setItem(key,value);
                            }catch (e){
                                console.log(e);
                            }
                        },
                        local_delete: function (key){
                            try{
                                localStorage.removeItem(key);
                            }catch (e){
                                console.log(e);
                            }
                        },
                        local_exist: function (key){
                            return this.get(key)!=undefined;
                        },
                        alert: function(msg){
                            this.$message(msg);
                        },
                        confirm: function(msg){
                            let that = this;
                            return new Promise((resolve, reject) => {
                                that.$confirm(msg,'提示',{
                                    confirmButtonText: '确定',
                                    cancelButtonText: '取消',
                                    type: 'warning'
                                }).then(resolve).catch(reject);
                            })
                        },
                        log: function (msg){
                            console.log(msg);
                        },
                        message : function (msg, type){
                            return this.$message({message:msg, type:type});
                        },
                        messageSuccess : function (msg){
                            return this.message(msg,"success");
                        },
                        messageWarn : function (msg){
                            return this.message(msg,"warn");
                        },
                        messageError : function (msg){
                            return this.message(msg,"error");
                        },
                        saveState : function(){
                            this.fireEvent("onSaveStateRequest",{});
                        },
                        a_click: function (url){


                            let aEle = $('<a id="_ff112233" class="testaaa" href="'+url+'" style="display: none;">aclick</a>')
                            $('body').append(aEle);
                            document.getElementById('_ff112233').click()
                            aEle.remove();

                            console.log('clicked a: '+url)
                        },

                        routeTo:function(path){
                            let u = $.url();
                           if((u.attr()['fragment'])==path ){
                               this.a_click('#_#_1');
                               this.a_click('#'+path);
                           }else{
                               this.a_click('#'+path);
                           }
                        },

                        url_get_parameter_app: function(){
                            let u = $.url();
                            return u.param('_internal_p');
                        },

                        url_get_parameter: function(name){
                            let u = $.url();
                            return u.param(u);
                        },

                        url_get_parameters: function(){
                            return $.url().param();
                        },

                        service: function(cmd,...args){
                            let tmp = cmd.split('.');
                            let p = {
                                bean:tmp[0],
                                method: tmp[1],
                                args
                            }
                            return new Promise(((resolve1, reject1) => {
                                this.ajax_post_json("/api/dmc/service",p).then((resp)=>{
                                    resolve1(resp);
                                }).catch((resp)=>{
                                    reject1(resp);
                                })
                            }))
                        },
                        cloneObject: function(obj){
                            return JSON.parse(JSON.stringify(obj));
                        },
                        util_uuid: function (len, radix) {
                            var chars = CHARS, uuid = [], i;
                            radix = radix || chars.length;

                            if (len) {
                                // Compact form
                                for (i = 0; i < len; i++) uuid[i] = chars[0 | Math.random()*radix];
                            } else {
                                // rfc4122, version 4 form
                                var r;

                                // rfc4122 requires these characters
                                uuid[8] = uuid[13] = uuid[18] = uuid[23] = '-';
                                uuid[14] = '4';

                                // Fill in random data.  At i==19 set the high bits of clock sequence as
                                // per rfc4122, sec. 4.1.5
                                for (i = 0; i < 36; i++) {
                                    if (!uuid[i]) {
                                        r = 0 | Math.random()*16;
                                        uuid[i] = chars[(i == 19) ? (r & 0x3) | 0x8 : r];
                                    }
                                }
                            }

                            return uuid.join('');
                        }
                    }
                });
                vueGlobal.$mount(el);

            }));
        }
        window['ApplicationInit']= ApplicationInit;

    })(jQuery)


</script>


