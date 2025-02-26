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
                            <div class="chart-container">
                                <canvas id="productCategoryChart"></canvas>
                            </div>
                        </div>
                        <div class="col-md-6">
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
                            <div class="chart-container">
                                <canvas id="revenueChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- Customer and Staff Chart -->
                    <div class="row mt-4">
                        <div class="col-md-6">
                            <h4>Customer & Staff</h4>
                            <h6>Customers: ${customerCount}</h6>
                            <h6>Staff: ${staffCount}</h6>
                            <div class="chart-container">
                                <canvas id="userCountChart"></canvas>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                var ctxRevenue = document.getElementById("revenueChart").getContext("2d");
                var ctxProduct = document.getElementById("productCategoryChart").getContext("2d");
                var ctxUser = document.getElementById("userCountChart").getContext("2d");

                var totalRevenue = parseFloat("${totalRevenue}") || 0;

                var categories = [];
                var productCounts = [];

            <c:forEach var="entry" items="${productCountByCategory}">
                categories.push("${entry.key}");
                productCounts.push(${entry.value});
            </c:forEach>

                // Biểu đồ doanh thu - Bar Chart với số hiển thị trên cột
                var revenueChart = new Chart(ctxRevenue, {
                    type: "bar",
                    data: {
                        labels: ["Total Revenue"],
                        datasets: [{
                                label: "Revenue",
                                data: [totalRevenue],
                                backgroundColor: "rgba(54, 162, 235, 0.7)",
                                borderColor: "rgba(54, 162, 235, 1)",
                                borderWidth: 2
                            }]
                    },
                    options: {
                        responsive: true,
                        animation: {
                            duration: 1500,
                            easing: 'easeInOutQuad'
                        },
                        scales: {
                            y: {
                                beginAtZero: true
                            }
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
                        }
                    }
                });

                // Gradient màu cho Line Chart
                var gradientStroke = ctxProduct.createLinearGradient(0, 0, 0, 400);
                gradientStroke.addColorStop(0, "rgba(75, 192, 192, 1)");
                gradientStroke.addColorStop(1, "rgba(153, 102, 255, 0.5)");

                var productCategoryChart = new Chart(ctxProduct, {
                    type: "line",
                    data: {
                        labels: categories,
                        datasets: [{
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
                            }]
                    },
                    options: {
                        responsive: true,
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
                        }
                    }
                });

                // Biểu đồ số lượng người dùng - Pie Chart với hiệu ứng đẹp
                var userCountChart = new Chart(ctxUser, {
                    type: 'pie',
                    data: {
                        labels: ['Customers', 'Staff'],
                        datasets: [{
                                label: 'User Count',
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
                            }]
                    },
                    options: {
                        responsive: true,
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
                        }
                    }
                });
            });

        </script>

    </body>
</html>
