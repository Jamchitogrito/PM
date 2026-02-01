using System.ComponentModel;
using System.Collections.ObjectModel;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using System.Runtime.CompilerServices;
using AvaloniaApplication1.Models;
using testtt.Models;

namespace testtt.ViewModels;

public class MainWindowViewModel: INotifyPropertyChanged
{
    public ObservableCollection<s> Suppliers { get; set; } = new()!;
    
    public MainWindowViewModel()
    {
        LoadData();
    }

    private void LoadData()
    {
        using var context = new ApplicationContext();
        context.Database.EnsureCreated();
        var s = context.Suppliers.ToList();
        foreach (var item in s)
        {
            Suppliers.Add(item);
            
        }
    }
    public event  PropertyChangedEventHandler? PropertyChanged;
    protected void OnPropertyChanged([CallerMemberName] string propertyName = null)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }
}