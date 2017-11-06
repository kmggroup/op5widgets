# Introduction - op5widgets

This is a collection of widgets, showing useful information from your op5 environment.

<img src=example.png width=800px>

# Dependencies

* Add the following to dashing's Gemfile:

```
gem 'httpclient'
gem "activesupport"
gem 'simple-rss'
gem "econfig", require: "econfig"
```

* Install gems

```
bundle install
```

# Usage

* Copy the widget directories into your ./widgets directory
  * op5hosts - Main overview
  * op5events - Last event happening in the monitor
  * op5serviceok - Ok Services
  * op5serviceack - Acknowledged issues
  * op5servicenoack - Non acknowledged issues

* Copy the jobs/op5widgets.rb into your ./jobs directory

* Create ./op5widgets.yml in your dashing root directory, and add your op5 servers and secrets. You can have one or many servers.

Example:

```
default_username: "myDashboardUser"
default_password: "secretpassword"

monitors:
  dev:        "https://dev.op5.example/api/"
  remote:     "https://remote.op5.example/api/"
  production: "https://production.op5.example/api/"
```

* Add the widgets to your dashboard, or create a new dashboard.

```
smashing generate dashboard op5
```

* NOTE: the data-id is "op5_" + the name you give the monitor instance in op5widgets.yml

```

        <!-- =========================== -->
        <!-- 1st column - overall status -->
        <!-- =========================== -->

        <li data-row="1" data-col="1" data-sizex="1" data-sizey="1">
              <div data-id="op5_dev" data-view="Op5hosts" data-title="INT" data-url="https://dev.op5.example"
                  data-addclass-dangerhost="hostDown"
                  data-addclass-dangerservice="serviceDown"
                  data-event-click="redirect">
              </div>
        </li>

        <!-- =========================== -->
        <!-- 2nd column - latest events  -->
        <!-- =========================== -->

        <li data-row="1" data-col="2" data-sizex="1" data-sizey="1">
            <div data-id="op5_int" data-view="Op5events"
                 data-addclass-intevacked="serviceAcked"
                 data-addclass-intevdanger="serviceCriticalNotAcked"
                 data-addclass-intevwarn="serviceWarningNotAcked">
            </div>
        </li>

        <!-- =========================== -->
        <!-- 3rd column - Services OK  -->
        <!-- =========================== -->

       <li data-row="1" data-col="3" data-sizex="1" data-sizey="1">
            <div data-id="op5_int" data-view="Op5servicesok"
                 data-addclass-insodanger="anyProblem" data-threshold=1>
            </div>
        </li>

        <!-- =========================== -->
        <!-- 4th column - Acknowledged  -->
        <!-- =========================== -->

        <li data-row="1" data-col="4" data-sizex="1" data-sizey="1">
            <div data-id="op5_int" data-view="Op5servicesack"
                 data-addclass-sunackedcrit="unAckedCritical"
                 data-addclass-sunackedwarn="unAckedWarning"
                 data-addclass-sallacked_crit="allAckedCrit"
                 data-addclass-sallacked_warn="allAckedWarn"
            >
            </div>
        </li>

        <!-- =========================== -->
        <!-- 5th column - Not acknowledged  -->
        <!-- =========================== -->

        <li data-row="1" data-col="5" data-sizex="1" data-sizey="1">
            <div data-id="op5_int" data-view="Op5servicesnoack"
                 data-addclass-snalarm="anyCritical"
                 data-addclass-snwarn="anyWarning"
            >
            </div>
        </li>
```

* Depending on your dashboard layout, you might want to edit your assets/javascript/applications.coffee script, and set the following variables:

```
  Dashing.widget_margins ||= [2, 3]
  Dashing.widget_base_dimensions ||= [255, 235]
  Dashing.numColumns ||= 5
```

# References

* https://smashing.github.io/ 

# License

Distributed under the [MIT license](MIT-LICENSE).

