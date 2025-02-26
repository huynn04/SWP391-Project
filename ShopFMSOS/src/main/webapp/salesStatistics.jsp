<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Sales Statistics Dashboard</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <style>
            body {
                padding-top: 56px;
            }
            .sidebar {
                height: 100vh;
                padding-top: 20px;
                background-color: #f8f9fa;
            }
            .sidebar a {
                color: #333;
                display: block;
                padding: 10px 15px;
                text-decoration: none;
            }
            .sidebar a:hover {
                background-color: #ddd;
            }
            .chart-container {
                width: 100%;
                height: 400px;
            }
        </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
            <a class="navbar-brand" href="dashboard">Admin Dashboard</a>
        </nav>

        <div class="container-fluid">
            <div class="row">
                <jsp:include page="sidebar.jsp" />
                <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
                    <div class="pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Sales Statistics</h1>
<<<<<<< Updated upstream
                        <!-- Breadcrumb hiển thị đường dẫn -->
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb breadcrumb-custom">
                                <li class="breadcrumb-item active" aria-current="page">Statistics</li>
                            </ol>
                        </nav>
                    </div>
                    <!-- Product Count and Revenue Charts -->
                    <div class="row">
                        <div class="col-md-6">
                            <h4>Product Count by Category</h4>
=======
                    </div>

                    <!-- Form để người dùng chọn năm và tháng -->
                    <form action="SalesStatistics" method="get">
                        <div class="form-group">
                            <label for="year">Year:</label>
                            <select id="year" name="year" class="form-control">
                                <option value="2024">2024</option>
                                <option value="2025">2025</option>
                                <option value="2026">2026</option>
                                <option value="2027">2027</option>
                                <option value="2028">2028</option>
                                <option value="2029">2029</option>
                                <option value="2030">2030</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="month">Month:</label>
                            <select id="month" name="month" class="form-control">
                                <option value="1">January</option>
                                <option value="2">February</option>
                                <option value="3">March</option>
                                <option value="4">April</option>
                                <option value="5">May</option>
                                <option value="6">June</option>
                                <option value="7">July</option>
                                <option value="8">August</option>
                                <option value="9">September</option>
                                <option value="10">October</option>
                                <option value="11">November</option>
                                <option value="12">December</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary">Submit</button>
                    </form>

                    <!-- Product Count and Revenue Charts -->
                    <div class="row">
                        <div class="col-md-6">
                            <h4>Product Count by Category </h4>
>>>>>>> Stashed changes
                            <div class="chart-container">
                                <canvas id="productCategoryChart"></canvas>
                            </div>
                        </div>
                        <div class="col-md-6">
<<<<<<< Updated upstream
                            <form action="SalesStatistics" method="get" class="form-inline">
                                <div class="form-group mx-2">
                                    <label for="year" class="mr-2">Year:</label>
                                    <select id="year" name="year" class="form-control form-control-sm w-auto">
                                        <option value="all" ${'all'.equals(year) ? 'selected' : ''}>All</option>
                                        <option value="2024" ${'2024'.equals(year) ? 'selected' : ''}>2024</option>
                                        <option value="2025" ${'2025'.equals(year) ? 'selected' : ''}>2025</option>
                                        <option value="2026" ${'2026'.equals(year) ? 'selected' : ''}>2026</option>
                                        <option value="2027" ${'2027'.equals(year) ? 'selected' : ''}>2027</option>
                                        <option value="2028" ${'2028'.equals(year) ? 'selected' : ''}>2028</option>
                                        <option value="2029" ${'2029'.equals(year) ? 'selected' : ''}>2029</option>
                                        <option value="2030" ${'2030'.equals(year) ? 'selected' : ''}>2030</option>
                                    </select>
                                </div>
                                <div class="form-group mx-2">
                                    <label for="month" class="mr-2">Month:</label>
                                    <select id="month" name="month" class="form-control form-control-sm w-auto">
                                        <option value="all" ${'all'.equals(month) ? 'selected' : ''}>All</option>
                                        <option value="1" ${'1'.equals(month) ? 'selected' : ''}>January</option>
                                        <option value="2" ${'2'.equals(month) ? 'selected' : ''}>February</option>
                                        <option value="3" ${'3'.equals(month) ? 'selected' : ''}>March</option>
                                        <option value="4" ${'4'.equals(month) ? 'selected' : ''}>April</option>
                                        <option value="5" ${'5'.equals(month) ? 'selected' : ''}>May</option>
                                        <option value="6" ${'6'.equals(month) ? 'selected' : ''}>June</option>
                                        <option value="7" ${'7'.equals(month) ? 'selected' : ''}>July</option>
                                        <option value="8" ${'8'.equals(month) ? 'selected' : ''}>August</option>
                                        <option value="9" ${'9'.equals(month) ? 'selected' : ''}>September</option>
                                        <option value="10" ${'10'.equals(month) ? 'selected' : ''}>October</option>
                                        <option value="11" ${'11'.equals(month) ? 'selected' : ''}>November</option>
                                        <option value="12" ${'12'.equals(month) ? 'selected' : ''}>December</option>
                                    </select>
                                </div>
                                <button type="submit" class="btn btn-primary btn-sm mx-2">Submit</button>
                            </form>
                            <h4>Total Revenue for ${year} - ${month}:</h4>
                            <h4><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="USD" /></h4>
=======
                            <h4>Total Revenue: <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="USD" /></h4>
>>>>>>> Stashed changes
                            <div class="chart-container">
                                <canvas id="revenueChart"></canvas>
                            </div>
                        </div>
                    </div>

<<<<<<< Updated upstream
                    <!-- Customer and Staff Chart -->
                    <div class="row mt-4">
                        <div class="col-md-6">
                            <h4>Customer & Staff</h4>
                            <h6>Customers: ${customerCount}</h6>
                            <h6>Staff: ${staffCount}</h6>
=======
                    <!-- New Users Chart (Customer and Staff) -->
                    <div class="row mt-4">
                        <div class="col-md-6">
                            <h4>Customer & Staff</h4>
>>>>>>> Stashed changes
                            <div class="chart-container">
                                <canvas id="userCountChart"></canvas>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>
<<<<<<< Updated upstream
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                var ctxRevenue = document.getElementById("revenueChart").getContext("2d");
                var ctxProduct = document.getElementById("productCategoryChart").getContext("2d");
                var ctxUser = document.getElementById("userCountChart").getContext("2d");

                var totalRevenue = parseFloat("${totalRevenue}") || 0;

=======

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                var ctxRevenue = document.getElementById("revenueChart").getContext("2d");
                var ctxProduct = document.getElementById("productCategoryChart").getContext("2d");
                var ctxUser = document.getElementById("userCountChart").getContext("2d");

                var totalRevenue = parseFloat("${totalRevenue}");

>>>>>>> Stashed changes
                var categories = [];
                var productCounts = [];

            <c:forEach var="entry" items="${productCountByCategory}">
                categories.push("${entry.key}");
                productCounts.push(${entry.value});
            </c:forEach>

<<<<<<< Updated upstream
                // Biểu đồ doanh thu - Bar Chart với số hiển thị trên cột
=======
                // Revenue Chart with animation
>>>>>>> Stashed changes
                var revenueChart = new Chart(ctxRevenue, {
                    type: "bar",
                    data: {
                        labels: ["Total Revenue"],
<<<<<<< Updated upstream
                        datasets: [{
                                label: "Revenue",
                                data: [totalRevenue],
                                backgroundColor: "rgba(54, 162, 235, 0.7)",
                                borderColor: "rgba(54, 162, 235, 1)",
                                borderWidth: 2
                            }]
=======
                        datasets: [
                            {
                                label: "Revenue",
                                data: [totalRevenue],
                                backgroundColor: "rgba(54, 162, 235, 0.5)",
                                borderColor: "rgba(54, 162, 235, 1)",
                                borderWidth: 1
                            }
                        ]
>>>>>>> Stashed changes
                    },
                    options: {
                        responsive: true,
                        animation: {
                            duration: 1500,
<<<<<<< Updated upstream
                            easing: 'easeInOutQuad'
=======
                            easing: 'easeInOutQuad',
                            onComplete: function () {
                                var chartInstance = this.chart;
                                var ctx = chartInstance.ctx;
                                ctx.textAlign = 'center';
                                ctx.fillStyle = 'black';
                                Chart.helpers.each(this.data.datasets[0].data, function (value, index) {
                                    var x = chartInstance.getDatasetMeta(0).data[index]._model.x;
                                    var y = chartInstance.getDatasetMeta(0).data[index]._model.y;
                                    ctx.fillText('$' + value.toFixed(2), x, y - 10);
                                });
                            }
>>>>>>> Stashed changes
                        },
                        scales: {
                            y: {
                                beginAtZero: true
                            }
<<<<<<< Updated upstream
                        },
                        plugins: {
                            tooltip: {
                                enabled: true
                            },
                            datalabels: {
                                anchor: 'end',
                                align: 'top',
                                formatter: (value) => "$" + value.toFixed(2),
                                font: {
                                    size: 14,
                                    weight: 'bold'
                                }
                            }
=======
>>>>>>> Stashed changes
                        }
                    }
                });

<<<<<<< Updated upstream
                // Gradient màu cho Line Chart
                var gradientStroke = ctxProduct.createLinearGradient(0, 0, 0, 400);
                gradientStroke.addColorStop(0, "rgba(75, 192, 192, 1)");
                gradientStroke.addColorStop(1, "rgba(153, 102, 255, 0.5)");

=======
                // Product Count by Category Chart
>>>>>>> Stashed changes
                var productCategoryChart = new Chart(ctxProduct, {
                    type: "line",
                    data: {
                        labels: categories,
                        datasets: [{
<<<<<<< Updated upstream
                                label: "Product Count by Category",
                                data: productCounts,
                                fill: true, // Tô màu dưới đường biểu đồ
                                backgroundColor: "rgba(75, 192, 192, 0.1)", // Màu nền mờ
                                borderColor: gradientStroke, // Gradient viền
                                borderWidth: 3,
                                tension: 0.4, // Làm mềm đường
                                pointBackgroundColor: "rgba(75, 192, 192, 1)", // Màu điểm
                                pointBorderColor: "#fff",
                                pointRadius: 5, // Kích thước điểm
                                pointHoverRadius: 8 // Phóng to điểm khi hover
=======
                                label: "Product Count",
                                data: productCounts,
                                borderColor: "rgba(75, 192, 192, 1)",
                                backgroundColor: "rgba(75, 192, 192, 0.2)",
                                borderWidth: 2,
                                tension: 0.4,
                                fill: true,
                                pointRadius: 5,
                                pointHoverRadius: 7
>>>>>>> Stashed changes
                            }]
                    },
                    options: {
                        responsive: true,
<<<<<<< Updated upstream
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                grid: {
                                    color: "rgba(200, 200, 200, 0.2)"
                                }
                            },
                            x: {
                                grid: {
                                    display: false
                                }
                            }
                        },
                        plugins: {
                            legend: {
                                labels: {
                                    font: {
                                        size: 14
                                    },
                                    color: "#555"
                                }
                            },
                            tooltip: {
                                backgroundColor: "rgba(0,0,0,0.7)",
                                titleFont: {
                                    size: 14
                                },
                                bodyFont: {
                                    size: 12
                                },
                                padding: 10,
                                cornerRadius: 5
                            }
                        },
                        animation: {
                            duration: 1500,
                            easing: "easeInOutQuart"
=======
                        scales: {
                            y: {
                                beginAtZero: true
                            }
                        },
                        animation: {
                            duration: 1000,
                            easing: 'easeOutBounce'
>>>>>>> Stashed changes
                        }
                    }
                });

<<<<<<< Updated upstream
                // Biểu đồ số lượng người dùng - Pie Chart với hiệu ứng đẹp
                var userCountChart = new Chart(ctxUser, {
                    type: 'pie',
=======
                // User Count Chart (Customers vs Staff)
                var userCountChart = new Chart(ctxUser, {
                    type: 'bar',
>>>>>>> Stashed changes
                    data: {
                        labels: ['Customers', 'Staff'],
                        datasets: [{
                                label: 'User Count',
<<<<<<< Updated upstream
                                data: [${customerCount}, ${staffCount}],
                                backgroundColor: [
                                    'rgba(54, 162, 235, 0.7)',
                                    'rgba(255, 99, 132, 0.7)'
                                ],
                                borderColor: [
                                    'rgba(54, 162, 235, 1)',
                                    'rgba(255, 99, 132, 1)'
                                ],
                                borderWidth: 2
=======
                                data: [${customerCount}, ${staffCount}], // Fetch from request
                                backgroundColor: ['rgba(54, 162, 235, 0.5)', 'rgba(75, 192, 192, 0.5)'],
                                borderColor: ['rgba(54, 162, 235, 1)', 'rgba(75, 192, 192, 1)'],
                                borderWidth: 1
>>>>>>> Stashed changes
                            }]
                    },
                    options: {
                        responsive: true,
<<<<<<< Updated upstream
                        plugins: {
                            legend: {
                                position: 'top',
                                labels: {
                                    font: {
                                        size: 14
                                    },
                                    color: "#444"
                                }
                            },
                            tooltip: {
                                backgroundColor: "rgba(0,0,0,0.8)",
                                bodyFont: {
                                    size: 14
                                },
                                padding: 10,
                                cornerRadius: 5
                            }
                        },
                        animation: {
                            animateScale: true,
                            animateRotate: true
=======
                        scales: {
                            y: {
                                beginAtZero: true
                            }
>>>>>>> Stashed changes
                        }
                    }
                });
            });
<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
        </script>

        <!-- Bootstrap and required scripts -->
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
        <script src="https://unpkg.com/feather-icons"></script>
        <script>
            feather.replace();
        </script>
    </body>
</html>
