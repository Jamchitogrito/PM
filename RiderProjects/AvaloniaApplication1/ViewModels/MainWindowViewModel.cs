using System.ComponentModel;
using System.Collections.ObjectModel;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using System.Runtime.CompilerServices;
using AvaloniaApplication1.Models;

namespace AvaloniaApplication1.ViewModels;

public class MainWindowViewModel: INotifyPropertyChanged
{
    public ObservableCollection<User> Users { get; set; } = new()!;

    public MainWindowViewModel()
    {
        LoadData();
    }

    private void LoadData()
    {
        using var context = new ApplicationContext();
        var users = context.Users.ToList();
        foreach (var user in users)
        {
            Users.Add(user);
        }
    }
    public event  PropertyChangedEventHandler? PropertyChanged;
    protected void OnPropertyChanged([CallerMemberName] string propertyName = null)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }
}