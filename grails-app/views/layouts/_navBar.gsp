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
                <sec:ifAnyUrls urls="/reports/showMcrs,/reports/showYearlySP">
                    <li>
                        <a href="#"><i class="fa fa-file-pdf-o"></i>&nbsp;Reports<span
                                class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <sec:ifAnyUrls urls="/reports/showYearlySP,/reports/showYearlySPDetails">
                                <li>
                                    <a href="#"><i class="fa fa-cubes"></i>&nbsp;Annual SAP<span
                                            class="fa arrow"></span></a>
                                    <ul class="nav nav-third-level">
                                        <sec:access url="/reports/showYearlySP">
                                            <li>
                                                <a href="#reports/showYearlySP"><i
                                                        class="fa fa-file-text-o"></i>&nbsp;Cumulative
                                                </a>
                                            </li>
                                        </sec:access>
                                        <sec:access url="/reports/showYearlySPDetails">
                                            <li>
                                                <a href="#reports/showYearlySPDetails"><i
                                                        class="fa fa-file-text-o"></i>&nbsp;Details
                                                </a>
                                            </li>
                                        </sec:access>
                                        <sec:access url="/reports/showSapBackupView">
                                            <li>
                                                <a href="#reports/showSapBackupView"><i
                                                        class="fa fa-file-text-o"></i>&nbsp;SAP Backup Files
                                                </a>
                                            </li>
                                        </sec:access>
                                    </ul>
                                </li>
                            </sec:ifAnyUrls>
                            <sec:access url="/reports/showMcrs">
                                <li>
                                    <a href="#reports/showMcrs"><i class="fa fa-object-ungroup"></i>&nbsp;MRP</a>
                                </li>
                            </sec:access>
                            <sec:access url="/reports/showEdDashBoard">
                                <li>
                                    <a href="#reports/showEdDashBoard"><i
                                            class="fa fa-object-group"></i>&nbsp;ED's Dashboard</a>
                                </li>
                            </sec:access>
                            <sec:access url="/reports/showSpSummary">
                                <li>
                                    <a href="#reports/showSpSummary"><i class="fa fa-keyboard-o"></i>&nbsp;SAP Summary
                                    </a>
                                </li>
                            </sec:access>
                            <sec:ifAnyUrls urls="/reports/showMeetingStatus,/meetingLog/showFunctional">
                                <li>
                                    <a href="#"><i class="fa fa-sitemap"></i>&nbsp;Meeting<span
                                            class="fa arrow"></span></a>
                                    <ul class="nav nav-third-level">
                                        <sec:access url="/reports/showMeetingStatus">
                                            <li>
                                                <a href="#reports/showMeetingStatus?type=Weekly">
                                                    <i class="fa fa-wikipedia-w"></i>&nbsp;Weekly
                                                </a>
                                            </li>
                                            <li>
                                                <a href="#reports/showMeetingStatus?type=Monthly">
                                                    <i class="fa fa-maxcdn"></i>&nbsp;Monthly
                                                </a>
                                            </li>
                                            <li>
                                                <a href="#reports/showMeetingStatus?type=Quarterly">
                                                    <i class="fa fa-quora"></i>&nbsp;Quarterly
                                                </a>
                                            </li>
                                            <li>
                                                <a href="#reports/showMeetingStatus?type=Annually"><i
                                                        class="fa fa-meetup"></i>&nbsp;Annually
                                                </a>
                                            </li>
                                        </sec:access>
                                        <sec:access url="/meetingLog/showFunctional">
                                            <li>
                                                <a href="#reports/showMeetingStatus?type=Functional"><i
                                                        class="fa fa-handshake-o"></i>&nbsp;Functional
                                                </a>
                                            </li>
                                        </sec:access>
                                    </ul>
                                </li>
                            </sec:ifAnyUrls>
                            <sec:ifAnyUrls urls="/reports/showSpStatus,reports/showMcrsStatus">
                                <li>
                                    <a href="#"><i class="fa fa-bar-chart-o"></i>&nbsp;Submission<span
                                            class="fa arrow"></span></a>
                                    <ul class="nav nav-third-level">
                                        <sec:access url="/reports/showMcrsStatus">
                                            <li>
                                                <a href="#reports/showMcrsStatus"><i
                                                        class="fa fa-file-text-o"></i>&nbsp;MCRS
                                                </a>
                                            </li>
                                        </sec:access>
                                        <sec:access url="/reports/showSpStatus">
                                            <li>
                                                <a href="#reports/showSpStatus"><i
                                                        class="fa fa-file-powerpoint-o"></i>&nbsp;SAP
                                                </a>
                                            </li>
                                        </sec:access>
                                    </ul>
                                </li>
                            </sec:ifAnyUrls>
                        </ul>
                        <!-- /.nav-second-level -->
                    </li>
                </sec:ifAnyUrls>
                <sec:ifAnyUrls urls="/meetingLog/show,/meetingLog/showQuarterAnnual,/meetingLog/showFunctional">
                    <li>
                        <a href="#"><i class="fa fa-sitemap"></i>&nbsp;Meeting<span
                                class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <sec:access url="/meetingLog/show">
                                <li>
                                    <a href="#meetingLog/show?type=Weekly"><i class="fa fa-wikipedia-w"></i>&nbsp;Weekly
                                    </a>
                                </li>
                                <li>
                                    <a href="#meetingLog/show?type=Monthly"><i class="fa fa-maxcdn"></i>&nbsp;Monthly
                                    </a>
                                </li>
                            </sec:access>
                            <sec:access url="/meetingLog/showQuarterAnnual">
                                <li>
                                    <a href="#meetingLog/showQuarterAnnual?type=Quarterly"><i
                                            class="fa fa-quora"></i>&nbsp;Quarterly
                                    </a>
                                </li>
                                <li>
                                    <a href="#meetingLog/showQuarterAnnual?type=Annually"><i
                                            class="fa fa-meetup"></i>&nbsp;Annually
                                    </a>
                                </li>
                            </sec:access>
                            <sec:access url="/meetingLog/showFunctional">
                                <li>
                                    <a href="#meetingLog/showFunctional?type=Functional"><i
                                            class="fa fa-handshake-o"></i>&nbsp;Functional
                                    </a>
                                </li>
                            </sec:access>
                        </ul>
                        <!-- /.nav-second-level -->
                    </li>
                </sec:ifAnyUrls>
                <sec:ifAnyUrls
                        urls="/pmMissions/show,/pmGoals/show,/pmActions/show,/pmSpSummary/show">
                    <li>
                        <a href="#"><i class="fa fa-book"></i>&nbsp;SAP Entry<span class="fa arrow"></span></a>
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
                                    <a href="#pmSpSummary/show"><i class="fa fa-newspaper-o"></i>&nbsp;SAP Summary</a>
                                </li>
                            </sec:access>
                            <sec:access url="/pmSpLog/showSubmission">
                                <li>
                                    <a href="#pmSpLog/showSubmission"><i class="fa fa-clock-o"></i>&nbsp;Submission</a>
                                </li>
                            </sec:access>
                        </ul>
                        <!-- /.nav-second-level -->
                    </li>
                </sec:ifAnyUrls>
                <sec:ifAnyUrls urls="/pmActions/achievement,/edDashboard/show,/pmMcrsLog/showSubmission">
                    <li>
                        <a href="#"><i class="fa fa-bars"></i>&nbsp;MCRS Entry<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <sec:access url="/pmActions/achievement">
                                <li>
                                    <a href="#pmActions/achievement"><i class="fa fa-hand-peace-o"></i>&nbsp;MRP</a>
                                </li>
                            </sec:access>
                            <sec:access url="/pmAdditionalActions/show">
                                <li>
                                    <a href="#pmAdditionalActions/show"><i
                                            class="fa fa-hand-peace-o"></i>&nbsp;MRP Additional</a>
                                </li>
                            </sec:access>
                            <sec:access url="/edDashboard/show">
                                <li>
                                    <a href="#edDashboard/show"><i class="fa fa-bar-chart"></i>&nbsp;ED's Dashboard</a>
                                </li>
                            </sec:access>
                            <sec:access url="/pmMcrsLog/showSubmission">
                                <li>
                                    <a href="#pmMcrsLog/showSubmission"><i class="fa fa-clock-o"></i>&nbsp;Submission
                                    </a>
                                </li>
                            </sec:access>
                        </ul>
                        <!-- /.nav-second-level -->
                    </li>
                </sec:ifAnyUrls>
                <sec:ifAnyUrls urls="/pmSpLog/show,/systemEntity/show,/pmServiceSector/show,/spTimeSchedule/show">
                    <li>
                        <a href="#"><i class="fa fa-wrench fa-fw"></i>&nbsp;Setting<span class="fa arrow"></span></a>
                        <ul class="nav nav-second-level">
                            <sec:access url="/pmSpLog/show">
                                <li>
                                    <a href="#pmSpLog/show"><i class="fa fa-clock-o"></i>&nbsp;SAP Log</a>
                                </li>
                            </sec:access>
                            <sec:access url="/pmMcrsLog/show">
                                <li>
                                    <a href="#pmMcrsLog/show"><i class="fa fa-clock-o"></i>&nbsp;MCRS Log</a>
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
                            <sec:access url="/XspTimeSchedule/show">
                                <li>
                                    <a href="#spTimeSchedule/show"><i class="fa fa-cogs"></i>&nbsp;SAP Schedule</a>
                                </li>
                            </sec:access>
                            <sec:access url="/pmProjects/show">
                                <li>
                                    <a href="#pmProjects/show"><i class="fa fa-cogs"></i>&nbsp;Projects</a>
                                </li>
                            </sec:access>
                            <sec:access url="/appMail/show">
                                <li>
                                    <a href="#appMail/show"><i class="fa fa-envelope-o"></i>&nbsp;Mail</a>
                                </li>
                            </sec:access>
                            <sec:access url="/quartz/show">
                                <li>
                                    <a href="#quartz/show"><i class="fa fa-tachometer"></i>&nbsp;Quartz</a>
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