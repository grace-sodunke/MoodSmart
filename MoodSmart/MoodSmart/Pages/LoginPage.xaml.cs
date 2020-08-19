using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;
using Xamarin.Auth;

namespace MoodSmart
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class LoginPage : ContentPage
    {
        public LoginPage()
        {
            InitializeComponent();
        }
        void LoginClick(object sender, EventArgs args)
        {
            Button btncontrol = (Button)sender;
            string providername = btncontrol.Text;
            if (OAuthConfig.User == null)
            {
                var loginprovider = new ProviderLoginPage(providername);
                Navigation.PushModalAsync(loginprovider);                  
            }
        }
    }
}