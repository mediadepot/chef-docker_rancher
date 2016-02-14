[![Circle CI](https://circleci.com/gh/mediadepot/chef-docker_rancher.svg?style=svg)](https://circleci.com/gh/mediadepot/chef-docker_rancher)
# chef-rancher-cookbook


TODO: Enter the cookbook description here.

## Supported Platforms

TODO: List your supported platforms.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['chef-rancher']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### chef-rancher::default

Include `chef-rancher` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[chef-rancher::default]"
  ]
}
```

## License and Authors

Author:: YOUR_NAME (<YOUR_EMAIL>)



knife cookbook site share docker_rancher -o ~/repos