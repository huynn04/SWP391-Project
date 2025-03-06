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
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb breadcrumb-custom">
                                <li class="breadcrumb-item active" aria-current="page">Statistics</li>
                            </ol>
                        </nav>
                    </div>
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
                            <c:choose>
                                <c:when test="${'all'.equals(year) && 'all'.equals(month)}">
                                    <h4>Total Revenue For All:</h4>
                                </c:when>
                                    <c:when test="${'all'.equals(year) && !'all'.equals(month)}">
                                    <h4>Total Revenue For Month ${month}:</h4>
                                </c:when>
                                <c:when test="${!'all'.equals(year) && 'all'.equals(month)}">
                                    <h4>Total Revenue For ${year}:</h4>
                                </c:when>
                                <c:otherwise>
                                    <h4>Total Revenue For ${month} ${year}:</h4>
                                </c:otherwise>
                            </c:choose>
                            <h4><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="USD" /></h4>
                            <div class="chart-container">
                                <canvas id="revenueChart"></canvas>
                            </div>
                        </div>
                    </div>

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
        <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2.0.0"></script>
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

                var revenueGradient = ctxRevenue.createLinearGradient(0, 0, 0, 400);
                revenueGradient.addColorStop(0, "rgba(54, 162, 235, 0.9)");
                revenueGradient.addColorStop(1, "rgba(54, 162, 235, 0.3)");

                var revenueChart = new Chart(ctxRevenue, {
                    type: "bar",
                    data: {
                        labels: ["Total Revenue"],
                        datasets: [{
                                label: "Revenue",
                                data: [totalRevenue],
                                backgroundColor: revenueGradient,
                                borderColor: "rgba(54, 162, 235, 1)",
                                borderWidth: 2,
                                borderRadius: 10,
                                borderSkipped: false
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        animation: {
                            duration: 2000,
                            easing: "easeOutBounce",
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                grid: {color: "rgba(200, 200, 200, 0.2)"},
                                ticks: {font: {size: 12}, color: "#666"}
                            },
                            x: {
                                grid: {display: false},
                                ticks: {font: {size: 12}, color: "#666"}
                            }
                        },
                        plugins: {
                            tooltip: {
                                backgroundColor: "rgba(0, 0, 0, 0.8)",
                                titleFont: {size: 14},
                                bodyFont: {size: 12},
                                padding: 12,
                                cornerRadius: 8
                            },
                            datalabels: {
                                anchor: "end",
                                align: "top",
                                formatter: (value) => "$" + value.toLocaleString("en-US", {minimumFractionDigits: 2}),
                                font: {size: 16, weight: "bold"},
                                color: "#333"
                            }
                        }
                    }
                });

                var productGradient = ctxProduct.createLinearGradient(0, 0, 0, 400);
                productGradient.addColorStop(0, "rgba(75, 192, 192, 1)");
                productGradient.addColorStop(1, "rgba(75, 192, 192, 0.2)");

                var productCategoryChart = new Chart(ctxProduct, {
                    type: "line",
                    data: {
                        labels: categories,
                        datasets: [{
                                label: "Product Count by Category",
                                data: productCounts,
                                fill: true,
                                backgroundColor: productGradient,
                                borderColor: "rgba(75, 192, 192, 1)",
                                borderWidth: 4,
                                tension: 0.4,
                                pointBackgroundColor: "rgba(75, 192, 192, 1)",
                                pointBorderColor: "#fff",
                                pointRadius: 6,
                                pointHoverRadius: 10,
                                pointStyle: "circle"
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        animation: {
                            duration: 2000,
                            easing: "easeInOutCubic"
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                grid: {color: "rgba(200, 200, 200, 0.2)"},
                                ticks: {font: {size: 12}, color: "#666"}
                            },
                            x: {
                                grid: {display: false},
                                ticks: {font: {size: 12}, color: "#666"}
                            }
                        },
                        plugins: {
                            legend: {
                                labels: {
                                    font: {size: 14, weight: "bold"},
                                    color: "#444"
                                }
                            },
                            tooltip: {
                                backgroundColor: "rgba(0, 0, 0, 0.8)",
                                titleFont: {size: 14},
                                bodyFont: {size: 12},
                                padding: 12,
                                cornerRadius: 8,
                                boxPadding: 5
                            }
                        }
                    }
                });

                var customerGradient = ctxUser.createLinearGradient(0, 0, 0, 400);
                customerGradient.addColorStop(0, "rgba(54, 162, 235, 0.9)");
                customerGradient.addColorStop(1, "rgba(54, 162, 235, 0.5)");

                var staffGradient = ctxUser.createLinearGradient(0, 0, 0, 400);
                staffGradient.addColorStop(0, "rgba(255, 99, 132, 0.9)");
                staffGradient.addColorStop(1, "rgba(255, 99, 132, 0.5)");

                var userCountChart = new Chart(ctxUser, {
                    type: "pie",
                    data: {
                        labels: ["Customers", "Staff"],
                        datasets: [{
                                label: "User Count",
                                data: [${customerCount}, ${staffCount}],
                                backgroundColor: [customerGradient, staffGradient],
                                borderColor: ["rgba(54, 162, 235, 1)", "rgba(255, 99, 132, 1)"],
                                borderWidth: 2,
                                hoverOffset: 10
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        animation: {
                            animateScale: true,
                            animateRotate: true,
                            duration: 1500,
                            easing: "easeOutElastic"
                        },
                        plugins: {
                            legend: {
                                position: "top",
                                labels: {
                                    font: {size: 14, weight: "bold"},
                                    color: "#444",
                                    padding: 20
                                }
                            },
                            tooltip: {
                                backgroundColor: "rgba(0, 0, 0, 0.8)",
                                titleFont: {size: 14},
                                bodyFont: {size: 12},
                                padding: 12,
                                cornerRadius: 8
                            },
                            datalabels: {
                                formatter: (value, ctx) => {
                                    let sum = ctx.dataset.data.reduce((a, b) => a + b, 0);
                                    let percentage = (value * 100 / sum).toFixed(1) + "%";
                                    return percentage;
                                },
                                color: "#fff",
                                font: {size: 14, weight: "bold"}
                            }
                        }
                    }
                });
            });
        </script>
    </body>
</html>