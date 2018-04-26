using System.Diagnostics;

namespace ContosoUniversity
{
    public class LoggingConfig
    {
        public static void Enable()
        {
            Trace.Listeners.Add(new ConsoleTraceListener());
            Trace.AutoFlush = true;
        }
    }
}