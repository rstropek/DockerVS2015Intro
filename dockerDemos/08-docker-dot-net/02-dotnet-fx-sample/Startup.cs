using Microsoft.Owin;
using Owin;

[assembly: OwinStartup(typeof(DotNetFxMiniSample.Startup))]

namespace DotNetFxMiniSample
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            app.Run(async context => await context.Response.WriteAsync("Hello World!"));
        }
    }
}
