using Avalonia.Controls;
using System.Windows.Controls;
using System.Windows.Navigation;

namespace TradeProjectAppAvalonia;

public partial class MainWindow : Window
{
    public MainWindow()
        {
            InitializeComponent();
            MainFrame.Navigate(new SignInPage());
        }

        private void MainFrame_Navigated(object sender, NavigationEventArgs e)
        {
            if (MainFrame.Content is Page currentPage)
            {
                switch (currentPage)
                {
                    case ProductsPage:

                        var productsPage = currentPage as ProductsPage;
                        productsPage?.LoadProductsAsync();
                        toBasketPageBtn.Visibility = Visibility.Visible;
                        UpdateBtn.Visibility = Visibility.Visible;

                        break;

                    case BasketPage:

                        var basketPage = currentPage as BasketPage;
                        basketPage?.UpdatePage();
                        break;

                    case SignInPage:

                        var signInPage = currentPage as SignInPage;
                        signInPage?.UpdatePage();
                        toBasketPageBtn.Visibility = Visibility.Collapsed;
                        UpdateBtn.Visibility = Visibility.Collapsed;
                        break;

                    default:
                        break;
                }

                HeaderTextBlock.Text = $"TradeProject - {currentPage.Title}";
                if (MainFrame.CanGoBack)
                {
                    BackButton.Visibility = Visibility.Visible;
                    UserTBlock.Text = "Пользователь: " +Session.user == null ? "" : Session.user.Role == 4 ? "Гость": Session.user.Name+" "+Session.user.Patronymic;
                }
                else
                {
                    BackButton.Visibility = Visibility.Collapsed;
                    UserTBlock.Text = "";

                }
            }
        }

        private void BackButton_Click(object sender, RoutedEventArgs e)
        {
            if (MainFrame.CanGoBack)
            {
                MainFrame.GoBack();
            }
            else
            {
                BackButton.Visibility = Visibility.Collapsed;
            }
        }
        private void UpdateBtn_Click(object sender, RoutedEventArgs e)
        {
            if (MainFrame.Content is Page currentPage)
            {
                switch (currentPage)
                {
                    case ProductsPage:

                        var productsPage = currentPage as ProductsPage;
                        productsPage?.UpdatePage();
                        break;

                    case EditProductPage:

                        var editProductPage = currentPage as EditProductPage;
                        editProductPage?.UpdatePage();
                        break;

                    case BasketPage:

                        var basketPage = currentPage as BasketPage;
                        basketPage?.UpdatePage();
                        break;

                    default:
                        break;
                }
            }
        }

        private void toBasketPageBtn_Click(object sender, RoutedEventArgs e)
        {
            MainFrame.NavigationService.Navigate(new BasketPage());
        }

        private void UpdatePageBtn_Click(object sender, RoutedEventArgs e)
        {

        }

        private void d_Click(object sender, RoutedEventArgs e)
        {

        }
}