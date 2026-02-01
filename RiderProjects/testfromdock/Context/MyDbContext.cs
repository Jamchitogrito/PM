using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;
using Pomelo.EntityFrameworkCore.MySql.Scaffolding.Internal;
using testfromdock.Models;

namespace testfromdock.Context;

public partial class MyDbContext : DbContext
{
    public MyDbContext()
    {
    }

    public MyDbContext(DbContextOptions<MyDbContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Eight> Eight { get; set; }

    public virtual DbSet<First> First { get; set; }

    public virtual DbSet<J> J { get; set; }

    public virtual DbSet<P> P { get; set; }

    public virtual DbSet<S> S { get; set; }

    public virtual DbSet<Second> Second { get; set; }

    public virtual DbSet<Seven> Seven { get; set; }

    public virtual DbSet<Spj> Spj { get; set; }

    public virtual DbSet<Third> Third { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseMySql("server=localhost;user=root;password=12345;database=details_db", Microsoft.EntityFrameworkCore.ServerVersion.Parse("12.1.2-mariadb"));

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder
            .UseCollation("utf8mb4_unicode_ci")
            .HasCharSet("utf8mb4");

        modelBuilder.Entity<Eight>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("eight");

            entity.Property(e => e.JId)
                .HasMaxLength(6)
                .HasColumnName("j_id");
            entity.Property(e => e.PId)
                .HasMaxLength(6)
                .HasColumnName("p_id");
            entity.Property(e => e.Quantity)
                .HasColumnType("int(11)")
                .HasColumnName("quantity");
            entity.Property(e => e.SId)
                .HasMaxLength(6)
                .HasColumnName("s_id");
        });

        modelBuilder.Entity<First>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("first");

            entity.Property(e => e.JId)
                .HasMaxLength(6)
                .HasColumnName("j_id");
        });

        modelBuilder.Entity<J>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("j");

            entity.Property(e => e.Id)
                .HasMaxLength(6)
                .HasColumnName("id");
            entity.Property(e => e.City)
                .HasMaxLength(20)
                .HasColumnName("city");
            entity.Property(e => e.Name)
                .HasMaxLength(20)
                .HasColumnName("name");
        });

        modelBuilder.Entity<P>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("p");

            entity.Property(e => e.Id)
                .HasMaxLength(6)
                .HasColumnName("id");
            entity.Property(e => e.City)
                .HasMaxLength(20)
                .HasColumnName("city");
            entity.Property(e => e.Color)
                .HasMaxLength(20)
                .HasColumnName("color");
            entity.Property(e => e.Name)
                .HasMaxLength(20)
                .HasColumnName("name");
            entity.Property(e => e.Weight)
                .HasColumnType("int(11)")
                .HasColumnName("weight");
        });

        modelBuilder.Entity<S>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PRIMARY");

            entity.ToTable("s");

            entity.Property(e => e.Id)
                .HasMaxLength(6)
                .HasColumnName("id");
            entity.Property(e => e.City)
                .HasMaxLength(20)
                .HasColumnName("city");
            entity.Property(e => e.Raiting)
                .HasColumnType("int(11)")
                .HasColumnName("raiting");
            entity.Property(e => e.Surname)
                .HasMaxLength(20)
                .HasColumnName("surname");
        });

        modelBuilder.Entity<Second>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("second");

            entity.Property(e => e.Idk)
                .HasPrecision(32)
                .HasColumnName("idk");
        });

        modelBuilder.Entity<Seven>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("seven");

            entity.Property(e => e.City)
                .HasMaxLength(20)
                .HasColumnName("city");
            entity.Property(e => e.Color)
                .HasMaxLength(20)
                .HasColumnName("color");
            entity.Property(e => e.Id)
                .HasMaxLength(6)
                .HasColumnName("id");
            entity.Property(e => e.Name)
                .HasMaxLength(20)
                .HasColumnName("name");
            entity.Property(e => e.Weight)
                .HasColumnType("int(11)")
                .HasColumnName("weight");
        });

        modelBuilder.Entity<Spj>(entity =>
        {
            entity.HasKey(e => new { e.SId, e.PId, e.JId })
                .HasName("PRIMARY")
                .HasAnnotation("MySql:IndexPrefixLength", new[] { 0, 0, 0 });

            entity.ToTable("spj");

            entity.HasIndex(e => e.JId, "j_id");

            entity.HasIndex(e => e.PId, "p_id");

            entity.Property(e => e.SId)
                .HasMaxLength(6)
                .HasColumnName("s_id");
            entity.Property(e => e.PId)
                .HasMaxLength(6)
                .HasColumnName("p_id");
            entity.Property(e => e.JId)
                .HasMaxLength(6)
                .HasColumnName("j_id");
            entity.Property(e => e.Quantity)
                .HasColumnType("int(11)")
                .HasColumnName("quantity");

            entity.HasOne(d => d.JIdNavigation).WithMany(p => p.Spj)
                .HasForeignKey(d => d.JId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("3");

            entity.HasOne(d => d.PIdNavigation).WithMany(p => p.Spj)
                .HasForeignKey(d => d.PId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("2");

            entity.HasOne(d => d.SIdNavigation).WithMany(p => p.Spj)
                .HasForeignKey(d => d.SId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("1");
        });

        modelBuilder.Entity<Third>(entity =>
        {
            entity
                .HasNoKey()
                .ToView("third");

            entity.Property(e => e.JId)
                .HasMaxLength(6)
                .HasColumnName("j_id");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
