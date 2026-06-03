export const regionOptions = [
  {
    value: '中国',
    label: '中国',
    children: [
      {
        value: '浙江',
        label: '浙江',
        children: [
          { value: '杭州', label: '杭州' },
          { value: '宁波', label: '宁波' },
          { value: '温州', label: '温州' },
          { value: '嘉兴', label: '嘉兴' },
          { value: '湖州', label: '湖州' },
          { value: '绍兴', label: '绍兴' },
          { value: '金华', label: '金华' },
          { value: '衢州', label: '衢州' },
          { value: '舟山', label: '舟山' },
          { value: '台州', label: '台州' },
          { value: '丽水', label: '丽水' }
        ]
      },
      {
        value: '江苏',
        label: '江苏',
        children: [
          { value: '南京', label: '南京' },
          { value: '苏州', label: '苏州' },
          { value: '无锡', label: '无锡' },
          { value: '常州', label: '常州' },
          { value: '南通', label: '南通' }
        ]
      },
      {
        value: '上海',
        label: '上海',
        children: [
          { value: '上海', label: '上海' }
        ]
      },
      {
        value: '北京',
        label: '北京',
        children: [
          { value: '北京', label: '北京' }
        ]
      },
      {
        value: '广东',
        label: '广东',
        children: [
          { value: '广州', label: '广州' },
          { value: '深圳', label: '深圳' },
          { value: '珠海', label: '珠海' },
          { value: '佛山', label: '佛山' },
          { value: '东莞', label: '东莞' }
        ]
      },
      {
        value: '四川',
        label: '四川',
        children: [
          { value: '成都', label: '成都' },
          { value: '绵阳', label: '绵阳' }
        ]
      }
    ]
  }
]

export const formatFullAddress = (row) => {
  if (row.country || row.province || row.city || row.addressDetail) {
    return [row.country, row.province, row.city, row.addressDetail].filter(Boolean).join(' ')
  }
  return row.address || '-'
}

export const buildAddressPayload = (region, addressDetail) => {
  const [country = '', province = '', city = ''] = region || []
  return {
    country,
    province,
    city,
    addressDetail: addressDetail || ''
  }
}

export const parseAddressRegion = (row) => {
  if (row.country && row.province && row.city) {
    return [row.country, row.province, row.city]
  }
  return []
}
