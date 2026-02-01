using System.Collections.ObjectModel;
using Avalonia.Controls;
using AvaloniaApplication1.Models;
using testtt.ViewModels;

namespace testtt;

public partial class MainWindow : Window
{
    public ObservableCollection<s> Suppliers { get; set; } = new();
    public MainWindow()
    {
        InitializeComponent();
        DataContext = new MainWindowViewModel();
    }
}