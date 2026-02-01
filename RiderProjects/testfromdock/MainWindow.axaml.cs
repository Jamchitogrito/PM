using System.Linq;
using Avalonia.Controls;
using testfromdock.Context;
using System.Linq;
using Avalonia.Interactivity;
using Microsoft.EntityFrameworkCore;
using testfromdock.Helpers;
using testfromdock.Models;
namespace testfromdock;

public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();
        using var context = new MyDbContext();
        var list = context.S.ToList();
        display_DataGrid.ItemsSource = list;
    }
    private void LoadDataFromSqlFile()
    {
            var sqlQuery = SqlFileReader.GetSqlQuery("GetData.sql");
            using var context = new MyDbContext();
            var data = context.Set<S>()
                .FromSqlRaw(sqlQuery)
                .AsNoTracking()
                .ToList();
            display_DataGrid.ItemsSource = data;
    }

    private void LoadDataFromLinQ()
    {
        using var context = new MyDbContext();
        var data = context.Set<S>();
        var list = data.ToList().Where(w => w.Raiting > 35);
        display_DataGrid.ItemsSource = list;
    }

    private void SelectFromSqlFile(object? sender, RoutedEventArgs e)
    {
        LoadDataFromSqlFile();
    }

    private void SelectFromLinQFile_Click(object? sender, RoutedEventArgs e)
    {
        LoadDataFromLinQ();
    }

    private void Reset_Click(object? sender, RoutedEventArgs e)
    {
        using var context = new MyDbContext();
        display_DataGrid.ItemsSource = context.S.ToList();
    }
}