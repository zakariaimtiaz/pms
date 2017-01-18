<!-- Navigation -->
<nav id="navbar" class="navbar navbar-default navbar-static-top" role="navigation"
     style="margin-bottom: 0;height: 2px;">
    <div class="navbar-header">
        <a style="padding-right: 2px;padding-top: 0;" class="navbar-brand" href="#login/dashBoard"><img
                src="images/logo.png" style="height: inherit;"/></a>
        <a style="padding-left: 120px;padding-top: 2px;" href=""><i id="spinner" class="fa fa-2x fa-refresh fa-spin"
                                                                    style="margin: 2px 4px;color:#9F9F9F"></i></a>
    </div>
    <!-- /.navbar-header -->

    <ul class="nav navbar-top-links navbar-right">
        <!-- /.dropdown -->
        <li class="dropdown">
        <li style="text-align: center">Welcome &nbsp;<strong><font color="green"><sec:fullName
                property='fullName'></sec:fullName>&nbsp;</font></strong></li>

        <a class="dropdown-toggle" data-toggle="dropdown" href="#">
            <i class="fa fa-user" style="font-size: 20px;"></i>  <i class="fa fa-caret-down"></i>
        </a>
        <ul class="dropdown-menu dropdown-user">
            <li>
                <a href="#login/resetPassword"><i class="fa fa-gear"></i>&nbsp;Reset password</a>
            </li>
            <li><a href="<g:createLink controller="logout"/>"><span
                    class="fa fa-sign-out"></span>&nbsp;Logout</a>
            </li>
        </ul>
        <!-- /.dropdown-user -->
    </li>
        <!-- /.dropdown -->
    </ul>
    <!-- /.navbar-top-links -->

    <div class="navbar-default sidebar" role="navigation">
        <div class="sidebar-nav navbar-collapse">
            <ul class="nav" id="side-menu">
                <sec:ifAnyUrls urls="/reports/showSpPlan,reports/showSpMonthlyPlan">
                    <li>
                        <a href="#"><i class="fa fa-server"></i>&nbsp;SP Views<span
                                class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <sec:access url="/reports/showSpPlan">
                                <li>
                                    <a href="#reports/showSpPlan"><i class="fa fa-cubes"></i>&nbsp;Yearly</a>
                                </li>
                            </sec:access>
                            <sec:access url="/reports/showSpMonthlyPlan">
                                <li>
                                    <a href="#reports/showSpMonthlyPlan"><i class="fa fa-cube"></i>&nbsp;Monthly
                                    </a>
                                </li>
                            </sec:access>
                            <sec:access url="/reports/showSpStatus">
                                <li>
                                    <a href="#reports/showSpStatus"><i class="fa fa-file-powerpoint-o"></i>&nbsp;SP Status
                                    </a>
                                </li>
                            </sec:access>
                        </ul>
                        <!-- /.nav-second-level -->
                    </li>
                </sec:ifAnyUrls>
                <sec:ifAnyUrls urls="/reports/showAllIndicator,reports/showActionsIndicator">
                    <li>
                        <a href="#"><i class="fa fa-file-pdf-o"></i>&nbsp;SP Reports<span
                                class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <sec:access url="/reports/showYearlySP">
                                <li>
                                    <a href="#reports/showYearlySP"><i class="fa fa-cubes"></i>&nbsp;Yearly SP</a>
                                </li>
                            </sec:access>
                            <sec:access url="/reports/showAllIndicator">
                                <li>
                                    <a href="#reports/showAllIndicator"><i class="fa fa-object-ungroup"></i>&nbsp;All Indicator</a>
                                </li>
                            </sec:access>
                            <sec:access url="/reports/showActionsIndicator">
                                <li>
                                    <a href="#reports/showActionsIndicator"><i class="fa fa-object-group"></i>&nbsp;Action Indicator</a>
                                </li>
                            </sec:access>
                        </ul>
                        <!-- /.nav-second-level -->
                    </li>
                </sec:ifAnyUrls>
                <sec:ifAnyUrls urls="/pmMissions/show,/pmGoals/show,/pmActions/show,/pmSprints/show,
                    /pmActions/achievement,/pmSpLog/showSubmission">
                    <li>
                        <a href="#"><i class="fa fa-book"></i>&nbsp;Entry Forms<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <sec:access url="/pmMissions/show">
                                <li>
                                    <a href="#pmMissions/show"><i class="fa fa-quote-right"></i>&nbsp;Missions</a>
                                </li>
                            </sec:access>
                            <sec:access url="/pmGoals/show">
                                <li>
                                    <a href="#pmGoals/show"><i class="fa fa-plane"></i>&nbsp;Goals</a>
                                </li>
                            </sec:access>
                            <sec:access url="/pmActions/show">
                                <li>
                                    <a href="#pmActions/show"><i class="fa fa-balance-scale"></i>&nbsp;Actions</a>
                                </li>
                            </sec:access>
                            <sec:access url="/pmSpSummary/show">
                                <li>
                                    <a href="#pmSpSummary/show"><i class="fa fa-newspaper-o"></i>&nbsp;SP Summary</a>
                                </li>
                            </sec:access>
                            <sec:access url="/pmSpLog/showSubmission">
                                <li>
                                    <a href="#pmSpLog/showSubmission"><i class="fa fa-clock-o"></i>&nbsp;SP Submission</a>
                                </li>
                            </sec:access>
                            <sec:access url="/pmActions/achievement">
                                <li>
                                    <a href="#pmActions/achievement"><i class="fa fa-hand-peace-o"></i>&nbsp;MRP</a>
                                </li>
                            </sec:access>
                            <sec:access url="/edDashboard/show">
                                <li>
                                    <a href="#edDashboard/show"><i class="fa fa-bar-chart"></i>&nbsp;ED's Dashboard</a>
                                </li>
                            </sec:access>

                        </ul>
                        <!-- /.nav-second-level -->
                    </li>
                </sec:ifAnyUrls>
            %{--                <sec:ifAnyUrls urls="/pmActions/achievement">
                                <li>
                                    <a href="#"><i class="fa fa-bars"></i>&nbsp;SP Versions<span class="fa arrow"></span></a>
                                    <ul class="nav nav-second-level">
                                        <sec:access url="/pmActions/achievement">
                                            <li>
                                                <a href="#pmActions/achievement"><i class="fa fa-sitemap"></i>&nbsp;Versions</a>
                                            </li>
                                        </sec:access>
                                    </ul>
                                    <!-- /.nav-second-level -->
                                </li>
                            </sec:ifAnyUrls>--}%
                <sec:ifAnyUrls urls="/pmSpLog/show,/systemEntity/show,/pmServiceSector/show,/spTimeSchedule/show">
                    <li>
                        <a href="#"><i class="fa fa-wrench fa-fw"></i>&nbsp;Setting<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <sec:access url="/pmSpLog/show">
                                <li>
                                    <a href="#pmSpLog/show"><i class="fa fa-clock-o"></i>&nbsp;SP Log</a>
                                </li>
                            </sec:access>
                            <sec:access url="/pmServiceSector/show">
                                <li>
                                    <a href="#pmServiceSector/show"><i class="fa fa-cog"></i>&nbsp;Sector/CSU</a>
                                </li>
                            </sec:access>
                            <sec:access url="/systemEntity/show">
                                <li>
                                    <a href="#systemEntity/show"><i class="fa fa-cogs"></i>&nbsp;System Entity</a>
                                </li>
                            </sec:access>
                            <sec:access url="/spTimeSchedule/show">
                                <li>
                                    <a href="#spTimeSchedule/show"><i class="fa fa-cogs"></i>&nbsp;SP Schedule</a>
                                </li>
                            </sec:access>
                            <sec:access url="/pmProjects/show">
                                <li>
                                    <a href="#pmProjects/show"><i class="fa fa-cogs"></i>&nbsp;Projects</a>
                                </li>
                            </sec:access>
                        </ul>
                        <!-- /.nav-second-level -->
                    </li>
                </sec:ifAnyUrls>
                <sec:ifAnyUrls
                        urls="/secUser/show,/secRole/show,/secUserSecRole/show,/featureManagement/show,/theme/show">
                    <li>
                        <a href="#"><i class="fa fa-users"></i>&nbsp;User Management<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <sec:access url="/secUser/show">
                                <li>
                                    <a href="#secUser/show"><i class="fa fa-user"></i>&nbsp;User</a>
                                </li>
                            </sec:access>
                            <sec:access url="/secRole/show">
                                <li>
                                    <a href="#secRole/show"><i class="fa fa-cog"></i>&nbsp;Role</a>
                                </li>
                            </sec:access>
                            <sec:access url="/featureManagement/show">
                                <li>
                                    <a href="#featureManagement/show"><i class="fa fa-cogs"></i>&nbsp;Role Right</a>
                                </li>
                            </sec:access>
                            <sec:access url="/login/showOnlineUser">
                                <li>
                                    <a href="#login/showOnlineUser"><i class="fa fa-binoculars"></i>&nbsp;Who is online</a>
                                </li>
                            </sec:access>
                        </ul>
                        <!-- /.nav-second-level -->
                    </li>
                </sec:ifAnyUrls>
            </ul>
        </div>
        <!-- /.sidebar-collapse -->
    </div>
    <!-- /.navbar-static-side -->
</nav>