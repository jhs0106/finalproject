<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="main-container">
<%--chat demo start--%>
  <div class="pd-ltr-20 xs-pd-20-10">
    <div class="min-height-200px">
      <div class="bg-white pd-20 card-box mb-30">
        <h4 class="h4 text-blue">Mixed Chart Demo</h4>
        <div id="chart5"></div>
      </div>
    </div>
<%--chart demo end--%>
<%--chat demo start--%>
    <div class="bg-white border-radius-4 box-shadow mb-30">
      <h4 class="h4 text-blue">Chat Demo</h4>
      <div class="row no-gutters">
        <div class="col-lg-3 col-md-4 col-sm-12">
          <div class="chat-list bg-light-gray">
            <div class="chat-search">
              <span class="ti-search"></span>
              <input type="text" placeholder="Search Contact" />
            </div>
            <div
                    class="notification-list chat-notification-list customscroll"
            >
              <ul>
                <li>
                  <a href="#">
                    <img src="/vendors/images/img.jpg" alt="" />
                    <h3 class="clearfix">John Doe</h3>
                    <p>
                      <i class="fa fa-circle text-light-green"></i> online
                    </p>
                  </a>
                </li>
                <li class="active">
                  <a href="#">
                    <img src="/vendors/images/img.jpg" alt="" />
                    <h3 class="clearfix">John Doe</h3>
                    <p>
                      <i class="fa fa-circle text-light-green"></i> online
                    </p>
                  </a>
                </li>
                <li>
                  <a href="#">
                    <img src="/vendors/images/img.jpg" alt="" />
                    <h3 class="clearfix">John Doe</h3>
                    <p>
                      <i class="fa fa-circle text-light-green"></i> online
                    </p>
                  </a>
                </li>
                <li>
                  <a href="#">
                    <img src="/vendors/images/img.jpg" alt="" />
                    <h3 class="clearfix">John Doe</h3>
                    <p>
                      <i class="fa fa-circle text-warning"></i> active 5
                      min
                    </p>
                  </a>
                </li>
                <li>
                  <a href="#">
                    <img src="/vendors/images/img.jpg" alt="" />
                    <h3 class="clearfix">John Doe</h3>
                    <p>
                      <i class="fa fa-circle text-warning"></i> active 4
                      min
                    </p>
                  </a>
                </li>
                <li>
                  <a href="#">
                    <img src="/vendors/images/img.jpg" alt="" />
                    <h3 class="clearfix">John Doe</h3>
                    <p>
                      <i class="fa fa-circle text-warning"></i> active 3
                      min
                    </p>
                  </a>
                </li>
                <li>
                  <a href="#">
                    <img src="/vendors/images/img.jpg" alt="" />
                    <h3 class="clearfix">John Doe</h3>
                    <p>
                      <i class="fa fa-circle text-light-orange"></i>
                      offline
                    </p>
                  </a>
                </li>
                <li>
                  <a href="#">
                    <img src="/vendors/images/img.jpg" alt="" />
                    <h3 class="clearfix">John Doe</h3>
                    <p>
                      <i class="fa fa-circle text-light-orange"></i>
                      offline
                    </p>
                  </a>
                </li>
                <li>
                  <a href="#">
                    <img src="/vendors/images/img.jpg" alt="" />
                    <h3 class="clearfix">John Doe</h3>
                    <p>
                      <i class="fa fa-circle text-light-orange"></i>
                      offline
                    </p>
                  </a>
                </li>
                <li>
                  <a href="#">
                    <img src="/vendors/images/img.jpg" alt="" />
                    <h3 class="clearfix">John Doe</h3>
                    <p>
                      <i class="fa fa-circle text-light-orange"></i>
                      offline
                    </p>
                  </a>
                </li>
                <li>
                  <a href="#">
                    <img src="/vendors/images/img.jpg" alt="" />
                    <h3 class="clearfix">John Doe</h3>
                    <p>
                      <i class="fa fa-circle text-light-orange"></i>
                      offline
                    </p>
                  </a>
                </li>
                <li>
                  <a href="#">
                    <img src="/vendors/images/img.jpg" alt="" />
                    <h3 class="clearfix">John Doe</h3>
                    <p>
                      <i class="fa fa-circle text-light-orange"></i>
                      offline
                    </p>
                  </a>
                </li>
              </ul>
            </div>
          </div>
        </div>
        <div class="col-lg-9 col-md-8 col-sm-12">
          <div class="chat-detail">
            <div class="chat-profile-header clearfix">
              <div class="left">
                <div class="clearfix">
                  <div class="chat-profile-photo">
                    <img src="/vendors/images/profile-photo.jpg" alt="" />
                  </div>
                  <div class="chat-profile-name">
                    <h3>Rachel Curtis</h3>
                    <span>New York, USA</span>
                  </div>
                </div>
              </div>
              <div class="right text-right">
                <div class="dropdown">
                  <a
                          class="btn btn-outline-primary dropdown-toggle"
                          href="#"
                          role="button"
                          data-toggle="dropdown"
                  >
                    Setting
                  </a>
                  <div class="dropdown-menu dropdown-menu-right">
                    <a class="dropdown-item" href="#">Export Chat</a>
                    <a class="dropdown-item" href="#">Search</a>
                    <a class="dropdown-item text-light-orange" href="#"
                    >Delete Chat</a
                    >
                  </div>
                </div>
              </div>
            </div>
            <div class="chat-box">
              <div class="chat-desc customscroll">
                <ul>
                  <li class="clearfix admin_chat">
													<span class="chat-img">
														<img src="/vendors/images/chat-img2.jpg" alt="" />
													</span>
                    <div class="chat-body clearfix">
                      <p>Maybe you already have additional info?</p>
                      <div class="chat_time">09:40PM</div>
                    </div>
                  </li>
                  <li class="clearfix admin_chat">
													<span class="chat-img">
														<img src="/vendors/images/chat-img2.jpg" alt="" />
													</span>
                    <div class="chat-body clearfix">
                      <p>
                        It is to early to provide some kind of estimation
                        here. We need user stories.
                      </p>
                      <div class="chat_time">09:40PM</div>
                    </div>
                  </li>
                  <li class="clearfix">
													<span class="chat-img">
														<img src="/vendors/images/chat-img1.jpg" alt="" />
													</span>
                    <div class="chat-body clearfix">
                      <p>
                        We are just writing up the user stories now so
                        will have requirements for you next week. We are
                        just writing up the user stories now so will have
                        requirements for you next week.
                      </p>
                      <div class="chat_time">09:40PM</div>
                    </div>
                  </li>
                  <li class="clearfix">
													<span class="chat-img">
														<img src="/vendors/images/chat-img1.jpg" alt="" />
													</span>
                    <div class="chat-body clearfix">
                      <p>
                        Essentially the brief is for you guys to build an
                        iOS and android app. We will do backend and web
                        app. We have a version one mockup of the UI,
                        please see it attached. As mentioned before, we
                        would simply hand you all the assets for the UI
                        and you guys code. If you have any early questions
                        please do send them on to myself. Ill be in touch
                        in coming days when we have requirements prepared.
                        Essentially the brief is for you guys to build an
                        iOS and android app. We will do backend and web
                        app. We have a version one mockup of the UI,
                        please see it attached. As mentioned before, we
                        would simply hand you all the assets for the UI
                        and you guys code. If you have any early questions
                        please do send them on to myself. Ill be in touch
                        in coming days when we have.
                      </p>
                      <div class="chat_time">09:40PM</div>
                    </div>
                  </li>
                  <li class="clearfix admin_chat">
													<span class="chat-img">
														<img src="/vendors/images/chat-img2.jpg" alt="" />
													</span>
                    <div class="chat-body clearfix">
                      <p>Maybe you already have additional info?</p>
                      <div class="chat_time">09:40PM</div>
                    </div>
                  </li>
                  <li class="clearfix admin_chat">
													<span class="chat-img">
														<img src="/vendors/images/chat-img2.jpg" alt="" />
													</span>
                    <div class="chat-body clearfix">
                      <p>
                        It is to early to provide some kind of estimation
                        here. We need user stories.
                      </p>
                      <div class="chat_time">09:40PM</div>
                    </div>
                  </li>
                  <li class="clearfix">
													<span class="chat-img">
														<img src="/vendors/images/chat-img1.jpg" alt="" />
													</span>
                    <div class="chat-body clearfix">
                      <p>
                        We are just writing up the user stories now so
                        will have requirements for you next week. We are
                        just writing up the user stories now so will have
                        requirements for you next week.
                      </p>
                      <div class="chat_time">09:40PM</div>
                    </div>
                  </li>
                  <li class="clearfix">
													<span class="chat-img">
														<img src="/vendors/images/chat-img1.jpg" alt="" />
													</span>
                    <div class="chat-body clearfix">
                      <p>
                        Essentially the brief is for you guys to build an
                        iOS and android app. We will do backend and web
                        app. We have a version one mockup of the UI,
                        please see it attached. As mentioned before, we
                        would simply hand you all the assets for the UI
                        and you guys code. If you have any early questions
                        please do send them on to myself. Ill be in touch
                        in coming days when we have requirements prepared.
                        Essentially the brief is for you guys to build an
                        iOS and android app. We will do backend and web
                        app. We have a version one mockup of the UI,
                        please see it attached. As mentioned before, we
                        would simply hand you all the assets for the UI
                        and you guys code. If you have any early questions
                        please do send them on to myself. Ill be in touch
                        in coming days when we have.
                      </p>
                      <div class="chat_time">09:40PM</div>
                    </div>
                  </li>
                  <li class="clearfix upload-file">
													<span class="chat-img">
														<img src="/vendors/images/chat-img1.jpg" alt="" />
													</span>
                    <div class="chat-body clearfix">
                      <div class="upload-file-box clearfix">
                        <div class="left">
                          <img
                                  src="/vendors/images/upload-file-img.jpg"
                                  alt=""
                          />
                          <div class="overlay">
                            <a href="#">
																		<span
                                                                        ><i class="fa fa-angle-down"></i
                                                                        ></span>
                            </a>
                          </div>
                        </div>
                        <div class="right">
                          <h3>Big room.jpg</h3>
                          <a href="#">Download</a>
                        </div>
                      </div>
                      <div class="chat_time">09:40PM</div>
                    </div>
                  </li>
                  <li class="clearfix upload-file admin_chat">
													<span class="chat-img">
														<img src="/vendors/images/chat-img2.jpg" alt="" />
													</span>
                    <div class="chat-body clearfix">
                      <div class="upload-file-box clearfix">
                        <div class="left">
                          <img
                                  src="/vendors/images/upload-file-img.jpg"
                                  alt=""
                          />
                          <div class="overlay">
                            <a href="#">
																		<span
                                                                        ><i class="fa fa-angle-down"></i
                                                                        ></span>
                            </a>
                          </div>
                        </div>
                        <div class="right">
                          <h3>Big room.jpg</h3>
                          <a href="#">Download</a>
                        </div>
                      </div>
                      <div class="chat_time">09:40PM</div>
                    </div>
                  </li>
                </ul>
              </div>
              <div class="chat-footer">
                <div class="file-upload">
                  <a href="#"><i class="fa fa-paperclip"></i></a>
                </div>
                <div class="chat_text_area">
                  <textarea placeholder="Type your message…"></textarea>
                </div>
                <div class="chat_send">
                  <button class="btn btn-link" type="submit">
                    <i class="icon-copy ion-paper-airplane"></i>
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
<%--chat demo end--%>
  </div>
</div>
<script>
  document.addEventListener("DOMContentLoaded", function () {
    var el = document.querySelector("#chart5");
    if (!el) return;

    var options = {
      series: [
        { name: "매출", type: "column", data: [10, 41, 35, 51, 49, 62, 69] },
        { name: "방문자", type: "line", data: [23, 42, 35, 27, 43, 22, 17] }
      ],
      chart: {
        height: 350,
        type: "line"
      },
      stroke: {
        width: [0, 4]
      },
      dataLabels: {
        enabled: true,
        enabledOnSeries: [1]
      },
      labels: ["월", "화", "수", "목", "금", "토", "일"],
      xaxis: {
        type: "category"
      },
      yaxis: [
        {
          title: {
            text: "매출"
          }
        },
        {
          opposite: true,
          title: {
            text: "방문자"
          }
        }
      ]
    };

    var chart = new ApexCharts(el, options);
    chart.render();
  });
</script>