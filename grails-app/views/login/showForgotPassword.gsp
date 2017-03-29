<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="cache-control" content="public"/>
    <title>Change Your Password</title>
    <link rel="shortcut icon" href="${createLinkTo(dir: 'images', file: 'favicon.png')}" type="image/x-icon"/>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'bootstrap/css/bootstrap.min.css')}"/>
    <script type="text/javascript"
            src="${resource(dir: 'js', file: 'jquery/jquery-1.11.2.min.js')}"></script>
    <script type="text/javascript"
            src="${resource(dir: 'js', file: 'bootstrap/bootstrap.min.js')}"></script>
    <style>
    body {
        background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' version='1.1' height='30px' width='100px'><text x='10' y='15' fill='lightgray' font-size='8'>Friendship</text></svg>");
    }
    </style>
</head>

<body>
<div class="container-fluid">
    <div class="row"  style="padding-top: 5%;padding-left: 30%;">

        <div class="col-md-7">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <div class="panel-title">
                        <div style="font-weight: bold">Change Password</div>
                    </div>
                </div>

                <div class="panel-body">
                    <form onsubmit="" action='${createLink(controller: 'login', action: 'managePassword')}'
                          method='POST' id='loginForm' class="form-horizontal form-widgets" role="form"
                          autocomplete='on'>
                        <input type="hidden" name='link' id='link' value="${userInfoMap?.passwordResetLink}"/>
                        <input type="hidden" name='username' id='username' value="${userInfoMap?.username}"/>

                        <div class="form-group">
                            <label class="col-md-4 control-label" for="username">Employee Name:</label>

                            <div class="col-md-8">
                                <span class="form-control">${userInfoMap?.empname}</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-4 control-label" for="username">Login ID:</label>
                            <div class="col-md-8">
                                <span class="form-control">${userInfoMap?.username}</span>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-4 control-label" for="code">Security Code:</label>

                            <div class="col-md-8">
                                <input type="text" class="form-control" id="code" name="code" tabindex="1"
                                       placeholder="Copy from your mail"/>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-4 control-label" for="password">New Password:</label>

                            <div class="col-md-8">
                                <input type="password" class="form-control" id="password" name="password"
                                       tabindex="2" placeholder="Type Password"/>

                            </div>
                        </div>

                        <div class="form-group">
                            <label class="col-md-4 control-label" for="password">Retype Password:</label>

                            <div class="col-md-8">
                                <input type="password" class="form-control" id="retypePassword" name="retypePassword"
                                       tabindex="3" placeholder="Type the password again"/>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-md-4">&nbsp;</div>

                            <div class="col-md-3">

                                <button id="create" name="create" type="submit" data-role="button"
                                        class="btn btn-default"
                                        role="button" tabindex="4"
                                        aria-disabled="false"><span class="glyphicon glyphicon-wrench"></span>&nbsp;Reset
                                </button>
                            </div>

                            <div class="col-md-5 pull-right">
                                <a href="${createLink(controller: 'login', action: 'auth')}"
                                   class="btn btn-default">
                                    <span class="glyphicon glyphicon-home"></span>&nbsp;Back to Sign In Page</a>
                            </div>
                        </div>

                        <div>
                            <g:if test="${flash.message && !flash.success}">
                                <div class='alert alert-danger col-md-12' id="login_msg_">${flash.message}</div>
                            </g:if>
                            <g:if test="${flash.message && flash.success}">
                                <div class='alert alert-success col-md-12' id="login_msg_">${flash.message}</div>
                            </g:if>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>