using System.Web.Mvc;

namespace ContosoUniversity.Logging
{
    public class ExceptionLoggerFilter : IExceptionFilter
    {
        public void OnException(ExceptionContext filterContext)
        {
            Logger.Instance.Error(filterContext.Exception.ToString(), filterContext.Exception.InnerException);
        }
    }
}