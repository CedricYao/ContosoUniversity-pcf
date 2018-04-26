using System;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using ContosoUniversity.DAL;
using System.Data.Entity.Infrastructure.Interception;
using System.Net;
using System.Web;
using ContosoUniversity.Logging;

namespace ContosoUniversity
{
    public class MvcApplication : HttpApplication
    {
        protected void Application_Start()
        {
            var environment = Environment.GetEnvironmentVariable("APP_ENVIRONMENT") ?? "development";

            AreaRegistration.RegisterAllAreas();
            GlobalFilters.Filters.Add(new ExceptionLoggerFilter());

            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            ApplicationConfig.RegisterConfig(environment);
            LoggingConfig.Enable();
            DbInterception.Add(new SchoolInterceptorTransientErrors());
            DbInterception.Add(new SchoolInterceptorLogging());

            // Checking DNS resolution of the connections string
            var host = "contosso-2016-pcfdemo.database.windows.net";
            Logger.Instance.Information($"Checking the DNS Entry for the host at - {host}");
            
            // application is displaying a yellow screen here.
            // "No such host is known"
            var addresses = Dns.GetHostAddresses(host);
            foreach (var ipAddress in addresses)
            {
                Logger.Instance.Information($"Address - {ipAddress}");
            }
        }
    }
}
