<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="cache-control" content="public"/>
    <link rel="shortcut icon" href="${createLinkTo(dir: 'images', file: 'favicon.ico')}" type="image/x-icon"/>
    <title>Login</title>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'bootstrap/css/bootstrap.min.css')}"/>
    <script type="text/javascript"
            src="${resource(dir: 'js', file: 'jquery/jquery-1.11.2.min.js')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js', file: 'bootstrap/bootstrap.min.js')}"></script>

    <style>
    body {
        background-image:url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' version='1.1' height='20px' width='35px'><text x='5' y='15' fill='lightgray' font-size='10'>SAP</text></svg>");
    }
    </style>
</head>

<body class="container-fluid" style="background-color: #F8F8F8;">
<div class="row" style="padding-top: 8%; padding-left: 30%;">
    <img src="${resource(dir: 'images', file: 'logo.png')}" alt="Friendship"/></div>

<div class="row" style="padding-left: 35%;">
    <div class="col-md-6">
        <div class="panel panel-default">
            <div class="panel-heading">
                <div class="panel-title">
                    <div class="row">
                        <div class="col-md-7" style="font-weight: bold">Sign In</div>
                    </div>
                </div>
            </div>

            <div class="panel-body">
                <g:if env="development">
                    <form action='${postUrl}' autocomplete='on'
                          method="post" class="form-horizontal form-widgets" role="form" id='loginForm'>

                        <div class="form-group">
                            <label class="col-md-3 control-label" for="username">Login ID:</label>

                            <div class="col-md-9">
                                <input type="text" class="form-control" id="username" name="j_username" tabindex="1"
                                       placeholder="Login ID" value="admin"/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-3 control-label" for="password">Password:</label>

                            <div class="col-md-9">

                                <input type="password" class="form-control" id="password" name="j_password"
                                       tabindex="2"
                                       placeholder="Password" value="fsadmin@123"/>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-md-3">&nbsp;</div>

                            <div class="col-md-5">
                                <button id="create" name="create" type="submit" class="btn btn-default" tabindex="3">
                                    <span class="glyphicon glyphicon-play"></span> Login
                                </button>
                            </div>

                            <div class="col-md-4" style="padding-right: 1px">
                                <a href="javascript:void(0);" tabindex="6"
                                   onclick="javascript:$('#forgotPassPanel').toggle(400);"><small>Forgot Password?</small>
                                </a>
                            </div>
                        </div>
                    </form>

                    <form onsubmit="" action='${createLink(controller: 'login', action: 'sendPasswordResetLink')}'
                          method='POST' class="form-horizontal form-widgets" role="form" style="padding-bottom: 4px">
                        <div class="form-group" id="forgotPassPanel" style="display: none;">
                            <div class="col-md-3">&nbsp;</div>

                            <div class="col-md-5">
                                <input type="text" class="form-control" id="loginId" name="loginId" tabindex="4"
                                       placeholder="Enter Login ID"/>
                            </div>

                            <div class="col-md-4">
                                <button type="submit" class="btn btn-default" tabindex="5">
                                    <span class="glyphicon glyphicon-envelope"></span> Send Mail
                                </button>
                            </div>
                        </div>
                    </form>
                </g:if>
                <g:if env="production">
                    <form action='${postUrl}' autocomplete='on'
                          method="post" class="form-horizontal form-widgets" role="form" id='loginForm'>

                        <div class="form-group">
                            <label class="col-md-3 control-label" for="username">Login ID:</label>

                            <div class="col-md-9">
                                <input type="text" class="form-control" id="username" name="j_username" tabindex="1"
                                       placeholder="Login ID" value=""/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-3 control-label" for="password">Password:</label>

                            <div class="col-md-9">

                                <input type="password" class="form-control" id="password" name="j_password"
                                       tabindex="2"
                                       placeholder="Password" value=""/>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-md-3">&nbsp;</div>

                            <div class="col-md-5">
                                <button id="create" name="create" type="submit" class="btn btn-default" tabindex="3">
                                    <span class="glyphicon glyphicon-play"></span> Login
                                </button>
                            </div>

                            <div class="col-md-4" style="padding-right: 1px">
                                <a href="javascript:void(0);" tabindex="6"
                                   onclick="javascript:$('#forgotPassPanel').toggle(400);"><small>Forgot Password?</small>
                                </a>
                            </div>
                        </div>
                    </form>

                    <form onsubmit="" action='${createLink(controller: 'login', action: 'sendPasswordResetLink')}'
                          method='POST' class="form-horizontal form-widgets" role="form" style="padding-bottom: 4px">
                        <div class="form-group" id="forgotPassPanel" style="display: none;">
                            <div class="col-md-3">&nbsp;</div>

                            <div class="col-md-5">
                                <input type="text" class="form-control" id="loginId" name="loginId" tabindex="4"
                                       placeholder="Enter Login ID"/>
                            </div>

                            <div class="col-md-4">
                                <button type="submit" class="btn btn-default" tabindex="5">
                                    <span class="glyphicon glyphicon-envelope"></span> Send Mail
                                </button>
                            </div>
                        </div>
                    </form>
                </g:if>
                <div>
                    <g:if test="${flash.message && !flash.success}">
                        <div class='alert alert-danger col-md-12' id="login_msg_"
                             style="margin-bottom: 0">${flash.message}</div>
                    </g:if>
                    <g:if test="${flash.message && flash.success}">
                        <div class='alert alert-success col-md-12' id="login_msg_"
                             style="margin-bottom: 0;">${flash.message}</div>
                    </g:if>
                </div>
            </div>

            <div class="panel-footer">
                <div class="copy-right" align="right" style="font-size: small;">Copyright <b>&copy;</b>
                    <script language="JavaScript" type="text/javascript">
                        var now = new Date;
                        var theYear = now.getYear();
                        if (theYear < 1900)
                            theYear = theYear + 1900;
                        document.write(theYear)
                    </script>&nbsp;<b>MIS</b>&nbsp;department</div>
            </div>
        </div>
    </div>
</div>
<script type="application/javascript">
    $(function () {
        $(document).on('keypress', 'input', function (e) {
            var id = $(this).attr('id'),
                    that = document.activeElement;
            if (e.which == 13 && id == 'username') {
                e.preventDefault();
                $('[tabIndex=' + (+that.tabIndex + 1) + ']')[0].focus();
            }
        });
    });

</script>
</body>
</html>
