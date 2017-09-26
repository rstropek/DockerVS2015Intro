using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;

namespace DotNetCoreMiniSample
{
    public class Program
    {
        public static void Main(string[] args)
        {
            WebHost.CreateDefaultBuilder(args)
                .UseUrls("http://*:5000")
                .Configure(app => app.Run(
                    async context => await context.Response.WriteAsync("Hello World!")))
                .Build()
                .Run();
        }
    }
}
