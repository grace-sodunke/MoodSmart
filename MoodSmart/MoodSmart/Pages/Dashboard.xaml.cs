using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace MoodSmart.Pages
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class Dashboard : ContentPage
    {
        public Dashboard()
        {            
            InitializeComponent();
        }
        void getName(object sender, EventArgs args)
        {
            Button btncontrol = (Button)sender;
            btncontrol.Text = OAuthConfig.TwitterUser.name;

        }
    }
}