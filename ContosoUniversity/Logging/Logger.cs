using System;
using System.Text;
using Serilog;

namespace ContosoUniversity.Logging
{
    public class Logger : ILogger
    {
        private static readonly Lazy<Logger> _logger = new Lazy<Logger>(() => new Logger());

        public static Logger Instance => _logger.Value;
        private readonly Serilog.ILogger _log;


        private Logger()
        {
            _log = new LoggerConfiguration().WriteTo.Console().CreateLogger();
        }

        public void Information(string message)
        {
            _log.Information(message);
        }

        public void Information(string fmt, params object[] vars)
        {
            _log.Information(fmt, vars);
        }

        public void Information(Exception exception, string fmt, params object[] vars)
        {
            _log.Information(FormatExceptionMessage(exception, fmt, vars));
        }

        public void Warning(string message)
        {
            _log.Warning(message);
        }

        public void Warning(string fmt, params object[] vars)
        {
            _log.Warning(fmt, vars);
        }

        public void Warning(Exception exception, string fmt, params object[] vars)
        {
            _log.Warning(FormatExceptionMessage(exception, fmt, vars));
        }

        public void Error(string message)
        {
            _log.Error(message);
        }

        public void Error(string fmt, params object[] vars)
        {
            _log.Error(fmt, vars);
        }

        public void Error(Exception exception, string fmt, params object[] vars)
        {
            _log.Error(FormatExceptionMessage(exception, fmt, vars));
        }

        public void TraceApi(string componentName, string method, TimeSpan timespan)
        {
            TraceApi(componentName, method, timespan, "");
        }

        public void TraceApi(string componentName, string method, TimeSpan timespan, string fmt, params object[] vars)
        {
            TraceApi(componentName, method, timespan, string.Format(fmt, vars));
        }
        public void TraceApi(string componentName, string method, TimeSpan timespan, string properties)
        {
            string message = String.Concat("Component:", componentName, ";Method:", method, ";Timespan:", timespan.ToString(), ";Properties:", properties);
            Log.Information(message);
        }

        private static string FormatExceptionMessage(Exception exception, string fmt, object[] vars)
        {
            // Simple exception formatting: for a more comprehensive version see 
            // http://code.msdn.microsoft.com/windowsazure/Fix-It-app-for-Building-cdd80df4
            var sb = new StringBuilder();
            sb.Append(string.Format(fmt, vars));
            sb.Append(" Exception: ");
            sb.Append(exception.ToString());
            return sb.ToString();
        }
    }
}