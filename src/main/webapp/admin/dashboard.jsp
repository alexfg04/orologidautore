<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css" type="text/css">

    <title>Dashboard</title>
</head>
<body>

<section>
    <div class="left-div">
        <br>
        <h2 class="logo">M - <span style="font-weight:100;"></span></h2>
        <hr class="hr"/>
        <ul class="nav">
            <li><a href=""><i class="fa fa-th-large"></i>Home</a></li>
            <li><a href=""><i class="fa fa-user"></i>User</a></li>
            <li class="active"><a href=""><i class="fa fa-key"></i>Access request</a></li>
            <li><a href=""><i class="fa fa-th-large"></i>Home</a></li>
            <li><a href=""><i class="fa fa-th-large"></i>Home</a></li>
        </ul>
        <br><br>
        <img src="${pageContext.request.contextPath}/admin/img/71218111_h.png" class="support" alt="Support Image">
    </div>

    <div class="right-div">
        <div id="main">
            <br>
            <div class="head">
                <div class="col-div-6">
                    <p>DashBoard</p>
                </div>
                <div class="col-div-6">
                    <div class="profile">
                        <img src="${pageContext.request.contextPath}/admin/img/711218111_h.png" class="pro-img" alt="Profile Image"/>
                        <p>Marco Doantiello<i class="fa fa-ellipsis-v dots"></i></p>
                        <div class="profile-div" style="display:none;">
                            <p><i class="fa fa-user"></i>&nbsp;&nbsp;Profile</p>
                            <p><i class="fa fa-cogs"></i>&nbsp;&nbsp;Settings</p>
                            <form action="${pageContext.request.contextPath}/logout" method="get" style="margin:0; padding:0;">
                                <button   type="submit">
                                    &nbsp;&nbsp;Log Out
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="clearfix"></div>
                <br><br><br>

                <!-- Box di esempio: Sales -->
                <div class="col-div-4-1">
                    <div class="box">
                        <br>
                        <p class="head-1">Sales</p>
                        <p class="number">675847</p>
                        <p class="percent"><i class="fa fa-long-arrow-up"></i>5.674% <span>Since Last Months</span></p>
                        <i class="fa fa-line-chart box-icon"></i>
                    </div>
                </div>

                <!-- Box di esempio: Purchases -->
                <div class="col-div-4-1">
                    <div class="box">
                        <br>
                        <p class="head-1">Purchases</p>
                        <p class="number">232342</p>
                        <p class="percent"><i class="fa fa-long-arrow-down"></i>12.674% <span>Since Last Months</span></p>
                        <i class="fa fa-circle-o-notch box-icon"></i>
                    </div>
                </div>

                <!-- Box di esempio: Orders -->
                <div class="col-div-4-1">
                    <div class="box">
                        <br>
                        <p class="head-1">Orders</p>
                        <p class="number">23244</p>
                        <p class="percent"><i class="fa fa-long-arrow-up"></i>5.674% <span>Since Last Months</span></p>
                        <i class="fa fa-shopping-bag box-icon"></i>
                    </div>
                </div>

                <div class="clearfix"></div>
                <br><br>

                <!-- Overview box -->
                <div class="col-div-4-1">
                    <div class="box-1">
                        <div class="content-box-1">
                            <p class="head-1">overview</p>
                            <br>
                            <div class="m-box active1">
                                <p>Member Profit<br><span class="no-1">Last Months</span></p>
                                <span class="no">+1133</span>
                            </div>

                            <div class="m-box">
                                <p>Member Profit<br><span class="no-1">Last Months</span></p>
                                <span class="no">+1133</span>
                            </div>

                            <div class="m-box">
                                <p>Member Profit<br><span class="no-1">Last Months</span></p>
                                <span class="no">+1133</span>
                            </div>

                            <div class="m-box">
                                <p>Member Profit<br><span class="no-1">Last Months</span></p>
                                <span class="no">+1133</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Total Sale box -->
                <div class="col-div-4-1">
                    <div class="box-1">
                        <div class="content-box-1">
                            <p class="head-1">Total Sale<span>View All</span></p>

                            <div class="circle-wrap">
                                <div class="circle">
                                    <div class="mask full">
                                        <div class="fill"></div>
                                    </div>
                                    <div class="mask half">
                                        <div class="fill"></div>
                                    </div>
                                    <div class="inside-circle">70%</div>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>

                <!-- Activity box -->
                <div class="col-div-4-1">
                    <div class="box-1">
                        <div class="content-box-1">
                            <p class="head-1">Activity <span>View All</span></p>
                            <br>
                            <p class="act-p"><i class="fa fa-circle"></i> Lorem Ipsum is simply dummy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>
                            <p class="act-p"><i class="fa fa-circle" style="color: red!important"></i> Lorem Ipsum is simply dummy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>
                            <p class="act-p"><i class="fa fa-circle" style="color: green!important"></i> Lorem Ipsum is simply dummy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>
                            <p class="act-p"><i class="fa fa-circle"></i> Lorem Ipsum is simply dummy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>
                        </div>
                    </div>
                </div>

                <div class="clearfix"></div>
            </div>
        </div>
    </div>

    <div class="clearfix"></div>
</section>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script type="text/javascript">
    $(document).ready(function() {
        $(".profile p").click(function(e) {
            e.preventDefault(); // evita ricarica o comportamento default
            $(".profile-div").toggle();
        });

        $('li').click(function(e) {
            e.preventDefault(); // blocca ricarica pagina se dentro c'è un link
            $('li').removeClass("active");
            $(this).addClass("active");
        });
    });
</script>


</body>
</html>
