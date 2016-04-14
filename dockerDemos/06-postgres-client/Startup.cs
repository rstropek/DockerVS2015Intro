using Dapper;
using Microsoft.AspNet.Builder;
using Microsoft.AspNet.Hosting;
using Microsoft.AspNet.Mvc;
using Microsoft.Extensions.DependencyInjection;
using Npgsql;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace PostgresClientDemo
{
    public class Startup
    {
        public void ConfigureServices(IServiceCollection services) => services.AddMvc();
        public void Configure(IApplicationBuilder app) => app.UseMvc();
        public static void Main(string[] args) => WebApplication.Run<Startup>(args);
    }

    public class Customer
    {
        public int ID { get; set; }

        public string CustomerName { get; set; }
    }

    [Route("api/customers")]
    public class CustomerController : Controller
    {
        [HttpGet]
        public async Task<IEnumerable<Customer>> Get()
        {
            // Note that in real world you would use the Options pattern
            // to get config options from config files and/or environment variables.
            var connectionString = $"Host={Environment.GetEnvironmentVariable("POSTGRES_HOST")};Username=postgres;Password=P@ssw0rd!";
            using (var conn = new NpgsqlConnection(connectionString))
            {
                await conn.OpenAsync();
                return await conn.QueryAsync<Customer>("SELECT * FROM Customers;");
            }
        }
    }
}
