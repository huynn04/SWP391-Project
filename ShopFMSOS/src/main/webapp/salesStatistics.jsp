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
                </div>

                <!-- Product Count and Revenue Charts -->
                <div class="row">
                    <div class="col-md-6">
                        <h4>Product Count by Category </h4>
                        <div class="chart-container">
                            <canvas id="productCategoryChart"></canvas>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <h4>Total Revenue: <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="USD" /></h4>
                        <div class="chart-container">
                            <canvas id="revenueChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- New Users Chart (Customer and Staff) -->
                <div class="row mt-4">
                    <div class="col-md-6">
                        <h4>Customer & Staff</h4>
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

            var totalRevenue = parseFloat("${totalRevenue}");

            var categories = [];
            var productCounts = [];

            <c:forEach var="entry" items="${productCountByCategory}">
                categories.push("${entry.key}");
                productCounts.push(${entry.value});
            </c:forEach>

            // Revenue Chart with animation
            var revenueChart = new Chart(ctxRevenue, {
                type: "bar",
                data: {
                    labels: ["Total Revenue"],
                    datasets: [
                        {
                            label: "Revenue",
                            data: [totalRevenue],
                            backgroundColor: "rgba(54, 162, 235, 0.5)",
                            borderColor: "rgba(54, 162, 235, 1)",
                            borderWidth: 1
                        }
                    ]
                },
                options: {
                    responsive: true,
                    animation: {
                        duration: 1500,
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
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });

            // Product Count by Category Chart
            var productCategoryChart = new Chart(ctxProduct, {
                type: "line",
                data: {
                    labels: categories,
                    datasets: [{
                        label: "Product Count",
                        data: productCounts,
                        borderColor: "rgba(75, 192, 192, 1)",
                        backgroundColor: "rgba(75, 192, 192, 0.2)",
                        borderWidth: 2,
                        tension: 0.4,
                        fill: true,
                        pointRadius: 5,
                        pointHoverRadius: 7
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    },
                    animation: {
                        duration: 1000,
                        easing: 'easeOutBounce'
                    }
                }
            });

            // User Count Chart (Customers vs Staff)
            var userCountChart = new Chart(ctxUser, {
                type: 'bar',
                data: {
                    labels: ['Customers', 'Staff'],
                    datasets: [{
                        label: 'User Count',
                        data: [${customerCount}, ${staffCount}], // Fetch from request
                        backgroundColor: ['rgba(54, 162, 235, 0.5)', 'rgba(75, 192, 192, 0.5)'],
                        borderColor: ['rgba(54, 162, 235, 1)', 'rgba(75, 192, 192, 1)'],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        });
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
