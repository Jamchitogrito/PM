using System;
using Microsoft.EntityFrameworkCore;
using Pomelo.EntityFrameworkCore.MySql.Infrastructure;
using Pomelo.EntityFrameworkCore.MySql.Scaffolding.Internal;

namespace AvaloniaApplication1.Models;

public class ApplicationContext : DbContext
{
    public DbSet<User> Users { get; set; } = null!;

    public ApplicationContext(DbContextOptions<ApplicationContext> options): base(options)
    {
        
    }

    public ApplicationContext()
    {
        
    }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        if (!optionsBuilder.IsConfigured)
        {
            var connectingString = "server=localhost;user=root;password=12345;database=AvaloniaApplication1";
            var serverVersion = ServerVersion.AutoDetect(connectingString);
            optionsBuilder.UseMySql(connectingString, serverVersion, MySqlOptions =>
            {
                MySqlOptions.EnableRetryOnFailure();
            });

        }
        
    }
}