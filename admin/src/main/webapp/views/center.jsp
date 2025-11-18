<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

  <div class="main-container">
    <div class="xs-pd-20-10 pd-ltr-20">
      <div class="title pb-20">
        <h2 class="h3 mb-0">시설 요약 확인</h2>
      </div>

      <div class="row pb-10">
        <div class="col-md-8 mb-20">
          <div class="card-box height-100-p pd-20">
            <div
                    class="d-flex flex-wrap justify-content-between align-items-center pb-0 pb-md-3"
            >
              <div class="h5 mb-md-0">사용자 방문</div>
              <div class="form-group mb-md-0">
                <select class="form-control form-control-sm selectpicker">
                  <option value="">Last Week</option>
                  <option value="">Last Month</option>
                  <option value="">Last 6 Month</option>
                  <option value="">Last 1 year</option>
                </select>
              </div>
            </div>
            <div id="activities-chart"></div>
          </div>
        </div>
        <div class="col-md-4 mb-20">
          <div
                  class="card-box min-height-200px pd-20 mb-20"
                  data-bgcolor="#455a64"
          >
            <div class="d-flex justify-content-between pb-20 text-white">
              <div class="icon h1 text-white">
                <i class="fa fa-calendar" aria-hidden="true"></i>
                <!-- <i class="icon-copy fa fa-stethoscope" aria-hidden="true"></i> -->
              </div>
              <div class="font-14 text-right">
                <div><i class="icon-copy ion-arrow-up-c"></i> 2.69%</div>
                <div class="font-12">Since last month</div>
              </div>
            </div>
            <div class="d-flex justify-content-between align-items-end">
              <div class="text-white">
                <div class="font-14">온도</div>
                <div class="font-24 weight-500">32.1</div>
              </div>
              <div class="max-width-150">
                <div id="appointment-chart"></div>
              </div>
            </div>
          </div>
          <div class="card-box min-height-200px pd-20" data-bgcolor="#265ed7">
            <div class="d-flex justify-content-between pb-20 text-white">
              <div class="icon h1 text-white">
                <i class="fa fa-stethoscope" aria-hidden="true"></i>
              </div>
              <div class="font-14 text-right">
                <div><i class="icon-copy ion-arrow-down-c"></i> 3.69%</div>
                <div class="font-12">Since last month</div>
              </div>
            </div>
            <div class="d-flex justify-content-between align-items-end">
              <div class="text-white">
                <div class="font-14">습도</div>
                <div class="font-24 weight-500">55%</div>
              </div>
              <div class="max-width-150">
                <div id="surgery-chart"></div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="row">
        <div class="col-lg-4 col-md-6 mb-20">
          <div class="card-box height-100-p pd-20 min-height-200px">
            <div class="d-flex justify-content-between pb-10">
              <div class="h5 mb-0">고객</div>
              <div class="dropdown">
                <a
                        class="btn btn-link font-24 p-0 line-height-1 no-arrow dropdown-toggle"
                        data-color="#1b3133"
                        href="#"
                        role="button"
                        data-toggle="dropdown"
                >
                  <i class="dw dw-more"></i>
                </a>
                <div
                        class="dropdown-menu dropdown-menu-right dropdown-menu-icon-list"
                >
                  <a class="dropdown-item" href="#"
                  ><i class="dw dw-eye"></i> View</a
                  >
                  <a class="dropdown-item" href="#"
                  ><i class="dw dw-edit2"></i> Edit</a
                  >
                  <a class="dropdown-item" href="#"
                  ><i class="dw dw-delete-3"></i> Delete</a
                  >
                </div>
              </div>
            </div>
            <div class="user-list">
              <ul>
                <li class="d-flex align-items-center justify-content-between">
                  <div class="name-avatar d-flex align-items-center pr-2">
                    <div class="avatar mr-2 flex-shrink-0">
                      <img
                              src="vendors/images/photo1.jpg"
                              class="border-radius-100 box-shadow"
                              width="50"
                              height="50"
                              alt=""
                      />
                    </div>
                    <div class="txt">
												<span
                                                        class="badge badge-pill badge-sm"
                                                        data-bgcolor="#e7ebf5"
                                                        data-color="#265ed7"
                                                >4.9</span
                                                >
                      <div class="font-14 weight-600">Dr. Neil Wagner</div>
                      <div class="font-12 weight-500" data-color="#b2b1b6">
                        Pediatrician
                      </div>
                    </div>
                  </div>
                  <div class="cta flex-shrink-0">
                    <a href="#" class="btn btn-sm btn-outline-primary"
                    >Schedule</a
                    >
                  </div>
                </li>
                <li class="d-flex align-items-center justify-content-between">
                  <div class="name-avatar d-flex align-items-center pr-2">
                    <div class="avatar mr-2 flex-shrink-0">
                      <img
                              src="vendors/images/photo2.jpg"
                              class="border-radius-100 box-shadow"
                              width="50"
                              height="50"
                              alt=""
                      />
                    </div>
                    <div class="txt">
												<span
                                                        class="badge badge-pill badge-sm"
                                                        data-bgcolor="#e7ebf5"
                                                        data-color="#265ed7"
                                                >4.9</span
                                                >
                      <div class="font-14 weight-600">Dr. Ren Delan</div>
                      <div class="font-12 weight-500" data-color="#b2b1b6">
                        Pediatrician
                      </div>
                    </div>
                  </div>
                  <div class="cta flex-shrink-0">
                    <a href="#" class="btn btn-sm btn-outline-primary"
                    >Schedule</a
                    >
                  </div>
                </li>
                <li class="d-flex align-items-center justify-content-between">
                  <div class="name-avatar d-flex align-items-center pr-2">
                    <div class="avatar mr-2 flex-shrink-0">
                      <img
                              src="vendors/images/photo3.jpg"
                              class="border-radius-100 box-shadow"
                              width="50"
                              height="50"
                              alt=""
                      />
                    </div>
                    <div class="txt">
												<span
                                                        class="badge badge-pill badge-sm"
                                                        data-bgcolor="#e7ebf5"
                                                        data-color="#265ed7"
                                                >4.9</span
                                                >
                      <div class="font-14 weight-600">Dr. Garrett Kincy</div>
                      <div class="font-12 weight-500" data-color="#b2b1b6">
                        Pediatrician
                      </div>
                    </div>
                  </div>
                  <div class="cta flex-shrink-0">
                    <a href="#" class="btn btn-sm btn-outline-primary"
                    >Schedule</a
                    >
                  </div>
                </li>
                <li class="d-flex align-items-center justify-content-between">
                  <div class="name-avatar d-flex align-items-center pr-2">
                    <div class="avatar mr-2 flex-shrink-0">
                      <img
                              src="vendors/images/photo4.jpg"
                              class="border-radius-100 box-shadow"
                              width="50"
                              height="50"
                              alt=""
                      />
                    </div>
                    <div class="txt">
												<span
                                                        class="badge badge-pill badge-sm"
                                                        data-bgcolor="#e7ebf5"
                                                        data-color="#265ed7"
                                                >4.9</span
                                                >
                      <div class="font-14 weight-600">Dr. Callie Reed</div>
                      <div class="font-12 weight-500" data-color="#b2b1b6">
                        Pediatrician
                      </div>
                    </div>
                  </div>
                  <div class="cta flex-shrink-0">
                    <a href="#" class="btn btn-sm btn-outline-primary"
                    >Schedule</a
                    >
                  </div>
                </li>
              </ul>
            </div>
          </div>
        </div>
        <div class="col-lg-4 col-md-6 mb-20">
          <div class="card-box height-100-p pd-20 min-height-200px">
            <div class="d-flex justify-content-between">
              <div class="h5 mb-0">고객 방문 지수</div>
              <div class="dropdown">
                <a
                        class="btn btn-link font-24 p-0 line-height-1 no-arrow dropdown-toggle"
                        data-color="#1b3133"
                        href="#"
                        role="button"
                        data-toggle="dropdown"
                >
                  <i class="dw dw-more"></i>
                </a>
                <div
                        class="dropdown-menu dropdown-menu-right dropdown-menu-icon-list"
                >
                  <a class="dropdown-item" href="#"
                  ><i class="dw dw-eye"></i> View</a
                  >
                  <a class="dropdown-item" href="#"
                  ><i class="dw dw-edit2"></i> Edit</a
                  >
                  <a class="dropdown-item" href="#"
                  ><i class="dw dw-delete-3"></i> Delete</a
                  >
                </div>
              </div>
            </div>

            <div id="diseases-chart"></div>
          </div>
        </div>
        <div class="col-lg-4 col-md-12 mb-20">
          <div class="card-box height-100-p pd-20 min-height-200px">
            <div class="h5 mb-0">시설 상태</div>
              <div id="chart5"></div>
          </div>
        </div>
      </div>



      <div class="title pb-20 pt-20">
        <h2 class="h3 mb-0">지금 바로 시작하세요.</h2>
      </div>

      <div class="row">
        <div class="col-md-4 mb-20">
          <a href="#" class="card-box d-block mx-auto pd-20 text-secondary">
            <div class="img pb-30">
              <img src="vendors/images/datalog.jpg" alt="" />
            </div>
            <div class="content">
              <h3 class="h4">데이터 로그 확인</h3>
              <p class="max-width-200">
                시설에 대한 모든 데이터 로그를 확인합니다.
              </p>
            </div>
          </a>
        </div>
        <div class="col-md-4 mb-20">
          <a href="#" class="card-box d-block mx-auto pd-20 text-secondary">
            <div class="img pb-30">
              <img src="vendors/images/iot.jpg"  alt="" />
            </div>
            <div class="content">
              <h3 class="h4">시설 장비 조작</h3>
              <p class="max-width-200">
                시설의 장비를 조작하세요.
              </p>
            </div>
          </a>
        </div>
        <div class="col-md-4 mb-20">
          <a href="#" class="card-box d-block mx-auto pd-20 text-secondary">
            <div class="img pb-30">
              <img src="vendors/images/cust.jpg" alt="" />
            </div>
            <div class="content">
              <h3 class="h4">고객대응</h3>
              <p class="max-width-200">
                실시간으로 고객을 관리하고, 응대하세요.
              </p>
            </div>
          </a>
        </div>
      </div>

      <div class="footer-wrap pd-20 mb-20 card-box" style="background-color: #eae7e7">
        © 2025 AI Culture Guide. All rights reserved.
      </div>
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