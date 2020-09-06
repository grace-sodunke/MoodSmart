using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace MoodSmart.Pages
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class Dashboard : ContentPage
    {
        FirebaseHelper firebaseHelper = new FirebaseHelper();
        public Dashboard()
        {            
            InitializeComponent();
        }
        async void getName(object sender, EventArgs args)
        {
            Button btncontrol = (Button)sender;

            //var httpClient = new HttpClient();
            string username = firebaseHelper.temp_getName()
                .ConfigureAwait(true)
                .GetAwaiter()
                .GetResult(); //this gets a string instead of a Task<string>
            //await httpClient.GetStringAsync(new Uri("https://moodsmart-e2625.firebaseio.com/twitter_user.json"));

            btncontrol.Text = username; // OAuthConfig.TwitterUser.name;

        }
    }
}